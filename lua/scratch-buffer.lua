local augroup = vim.api.nvim_create_augroup("nvim.scratchpad.rs", { clear = true })

local M = {
    temp_dir = "/tmp/nvim.scratchpad.rs",

    buf = nil,

    buf_name = nil,
}

local function create_buffer()
    local work_dir = vim.uv.cwd()
    vim.cmd("cd " .. M.temp_dir)

    local buf = vim.api.nvim_create_buf(true, false)
    M.buf_name = 'scratch_'..require('os').time()..'.rs'
    vim.api.nvim_buf_set_name(buf, M.buf_name)
    vim.api.nvim_set_option_value("filetype", "rust", { buf = buf })

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "// scratch.rs", "" })
    vim.api.nvim_buf_set_lines(buf, 2, -1, true, { "fn main() {", "" })
    vim.api.nvim_buf_set_lines(buf, 3, -1, true, { "\tprintln!(\"Hello world!\")", "" })
    vim.api.nvim_buf_set_lines(buf, 4, -1, true, { "}", "" })

    M.buf = buf
    vim.cmd("cd " .. work_dir)

    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf) - 1, 0 })
end

local function run()

    if vim.fn.executable('rustc') == 0 then
        print("rustc not found")
        return
    end

    local work_dir = vim.uv.cwd()
    vim.cmd("cd " .. M.temp_dir)

    local comptime_result = vim.fn.system('rustc -o scratch '..M.buf_name)
    if comptime_result ~= nil then
        print(comptime_result)
    end

    local runtime_result = vim.fn.system('./scratch')
    if runtime_result ~= nil then
        print(runtime_result)
    end
    os.remove(vim.fn.expand "scratch")

    vim.cmd("cd " .. work_dir)
end

local function cleanup()
    local work_dir = vim.uv.cwd()
    vim.cmd("cd " .. M.temp_dir)

    os.remove(vim.fn.expand(M.buf_name))
    vim.api.nvim_buf_delete(M.buf, { force = true })

    vim.cmd("cd " .. work_dir)
end

local function setup_events()
    vim.api.nvim_create_autocmd("BufWritePost",
        {
            group = augroup,
            desc = "change to temporary scratch directory",
            once = false,
            callback = run
    })
    vim.api.nvim_create_autocmd("ExitPre",
        {
            group = augroup,
            desc = "change to temporary scratch directory",
            once = false,
            callback = cleanup
    })
end

local function main()
    if M.buf ~= nil then
        vim.api.nvim_win_set_buf(0, M.buf)
    else
        create_buffer()
    end
end

function M.setup(opts)
    -- Set defaults
    opts = opts or {}
    if opts.temp_dir ~= nil then
        M.temp_dir = opts.temp_dir
    end

    os.execute("mkdir -p " .. M.temp_dir)
    vim.api.nvim_create_user_command('Scratchpad', main, {})

    setup_events()
end

return M
