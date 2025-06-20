# Python Development in Neovim - Complete Guide

This guide provides step-by-step instructions for using your Neovim Python configuration with the test examples.

## Prerequisites

1. **Start your development environment:**
   ```bash
   cd /Users/andreszambrano/Dev/mac-config/cli-config
   nix develop
   ```

2. **Navigate to the Python test directory:**
   ```bash
   cd python-test
   ```

## Part 1: Basic Python Development

### Opening Files in Neovim

1. **Start Neovim with a Python file:**
   ```bash
   nvim src/calculator.py
   ```

2. **What you should see:**
   - Syntax highlighting for Python
   - Line numbers
   - Git status indicators (if in a git repo)
   - Status line with file information

### LSP Features (Pyright)

#### Auto-completion
1. **Open `src/calculator.py`**
2. **Go to line 50** (inside a function)
3. **Type `calc.` and wait** - you should see completion suggestions
4. **Use `Tab` or `Enter`** to accept completions

#### Go to Definition
1. **Place cursor on `Calculator` class usage**
2. **Press `gd`** - jumps to class definition
3. **Press `Ctrl-o`** - jumps back

#### Show Documentation
1. **Place cursor on any function call**
2. **Press `K`** - shows documentation hover
3. **Press `K` again** to enter the hover window

#### Find References
1. **Place cursor on `add` method name**
2. **Press `gr`** - shows all references to this method

#### Diagnostics (Error checking)
1. **Add an intentional error:** Change `def add(self, a, b):` to `def add(self, a, b, c):`
2. **Save the file:** `:w`
3. **See error indicators** in the gutter and underlines
4. **View all diagnostics:** `:lua vim.diagnostic.open_float()`

### Python-Specific Features

#### Running Python Files
1. **Open `src/calculator.py`**
2. **Run the file:** `<leader>nr` (leader + n + r)
3. **Run interactively:** `<leader>ni` (leader + n + i)

#### Code Formatting
1. **Format with Black:** `<leader>ff` (leader + f + f)
2. **Sort imports:** `<leader>ns` (leader + n + s)

#### Docstring Generation
1. **Place cursor on a function definition line**
2. **Press `<leader>nd`** (leader + n + d)
3. **Edit the generated docstring template**

### Testing with Pytest

#### Running Tests
1. **Run all tests:** `<leader>nt` (leader + n + t)
2. **Run current file tests:** `<leader>nT` (leader + n + T)

#### Running Tests Manually
```bash
# In terminal (from python-test directory)
pytest
pytest tests/test_calculator.py
pytest tests/test_calculator.py::TestCalculator::test_add
pytest -v  # verbose output
pytest --cov=src  # with coverage
```

## Part 2: File Navigation and Management

### File Explorer
1. **Open file explorer:** `-` (minus key)
2. **Navigate:** Use arrow keys or `hjkl`
3. **Open file:** `Enter`
4. **Create file:** `%` then type filename
5. **Create directory:** `d` then type dirname
6. **Go to parent:** `-`

### Telescope (Fuzzy Finder)
1. **Find files:** `<leader>sf` (leader + s + f)
2. **Live grep:** `<leader>sg` (leader + s + g)
3. **Help tags:** `<leader>sh` (leader + s + h)

### Quick Navigation
1. **Switch between files:** `Ctrl-6`
2. **Go to definition:** `gd`
3. **Go back:** `Ctrl-o`
4. **Go forward:** `Ctrl-i`

## Part 3: Debugging with DAP

### Setting Up Debugging

1. **Open the debug example:**
   ```bash
   nvim debug_example.py
   ```

2. **Basic DAP Commands:**
   - `<F5>` - Start/Continue debugging
   - `<F10>` - Step over
   - `<F11>` - Step into
   - `<F12>` - Step out
   - `<leader>db` - Toggle breakpoint
   - `<leader>dr` - Open REPL

### Step-by-Step Debugging Tutorial

#### 1. Simple Breakpoint Debugging

1. **Open `debug_example.py`**
2. **Go to line 45** (inside `complex_calculation`)
3. **Set a breakpoint:** `<leader>db`
4. **Start debugging:** `<F5>`
5. **Select configuration:** Choose "Launch file"
6. **Step through code:** Use `<F10>` to step over lines
7. **Inspect variables:** Hover over variables or check the variables window

#### 2. Step Into Function Calls

1. **Set breakpoint at line 65** (inside the for loop)
2. **Start debugging:** `<F5>`
3. **When at `calc.power(num, 2)`:**
   - **Step into:** `<F11>` - enters the function
   - **Step out:** `<F12>` - returns to caller

#### 3. Conditional Breakpoints

1. **Set breakpoint at line 100** (in `conditional_breakpoint_example`)
2. **Make it conditional:**
   - Right-click breakpoint or use command
   - Add condition: `i == 5`
3. **Run debugging** - will only stop when i equals 5

#### 4. Variable Inspection

1. **Set breakpoint at line 130** (in `variable_inspection_example`)
2. **Start debugging**
3. **Inspect variables:**
   - **DAP Variables window** shows current scope
   - **Hover over variables** for quick values
   - **Use REPL** to evaluate expressions

#### 5. Debugging Errors

1. **Open `debug_example.py`**
2. **Run the buggy function:**
   ```bash
   python debug_example.py
   ```
3. **Note the error location**
4. **Set breakpoint before the error** (line 18)
5. **Debug to see the problem:**
   - Step through to see when `i` becomes 3
   - Inspect the division by zero

### Advanced Debugging Features

#### Using the Debug REPL
1. **During debugging session**
2. **Open REPL:** `<leader>dr`
3. **Execute Python code** in current context
4. **Example commands:**
   ```python
   print(f"Current value of num: {num}")
   calc.get_history()
   len(numbers)
   ```

#### Virtual Environment Detection
- The debugger automatically detects virtual environments
- Checks for `venv/bin/python` or `.venv/bin/python`
- Falls back to system Python if none found

## Part 4: Complete Workflow Examples

### Example 1: Developing a New Feature

1. **Open the calculator module:**
   ```bash
   nvim src/calculator.py
   ```

2. **Add a new method** (use auto-completion):
   ```python
   def square_root(self, n):
       import math
       result = math.sqrt(n)
       operation = f"√{n} = {result}"
       self.history.append(operation)
       return result
   ```

3. **Format the code:** `<leader>ff`

4. **Create a test**:
   ```bash
   nvim tests/test_calculator.py
   ```

5. **Add test method:**
   ```python
   def test_square_root(self):
       result = self.calc.square_root(16)
       assert result == 4.0
   ```

6. **Run the specific test:** `<leader>nT`

### Example 2: Debugging a Web API

1. **Open the web demo:**
   ```bash
   nvim src/web_demo.py
   ```

2. **Set breakpoint** in `demo_github_api` function

3. **Debug the file:**
   - Start debugging: `<F5>`
   - Choose "Launch file"
   - Step through API calls
   - Inspect response data

4. **Use REPL to test API calls:**
   ```python
   # In debug REPL
   response = github.get_user_info("octocat")
   print(response)
   ```

### Example 3: Data Processing Pipeline

1. **Open data processor:**
   ```bash
   nvim src/data_processor.py
   ```

2. **Run the main function:** `<leader>nr`

3. **Check generated files:**
   ```bash
   ls data/
   cat data/sample_data.json
   ```

4. **Debug data analysis:**
   - Set breakpoint in `analyze_numbers`
   - Step through calculations
   - Inspect statistical computations

## Part 5: Productivity Tips

### Key Mappings Summary

| Key Combination | Action |
|----------------|--------|
| `<leader>nr` | Run Python file |
| `<leader>ni` | Run Python interactively |
| `<leader>ff` | Format with Black |
| `<leader>ns` | Sort imports |
| `<leader>nt` | Run pytest |
| `<leader>nT` | Run pytest on current file |
| `<leader>nd` | Insert docstring template |
| `<F5>` | Start/Continue debugging |
| `<F10>` | Debug step over |
| `<F11>` | Debug step into |
| `<F12>` | Debug step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dr` | Open debug REPL |

### LSP Key Mappings

| Key Combination | Action |
|----------------|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Show documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Quick Tips

1. **Use `:checkhealth` to verify LSP setup**
2. **`:LspInfo` shows active language servers**
3. **`:Mason` opens plugin manager (if not using Nix)**
4. **Use `gcc` to comment/uncomment lines**
5. **`Ctrl-]` jumps to tag, `Ctrl-t` jumps back**

## Troubleshooting

### LSP Not Working
1. **Check if pyright is available:** `:!which pyright`
2. **Check LSP status:** `:LspInfo`
3. **Restart LSP:** `:LspRestart`

### Debugging Not Starting
1. **Verify debugpy is installed:** `:!python -m debugpy --version`
2. **Check DAP configuration:** `:lua print(vim.inspect(require('dap').configurations.python))`

### Tests Not Running
1. **Ensure pytest is available:** `:!which pytest`
2. **Check Python path:** `:!python -c "import sys; print(sys.path)"`
3. **Run manually first:** `:!pytest -v`

### Import Errors
1. **Add project root to Python path** in your test files
2. **Use absolute imports** when possible
3. **Check `__init__.py` files** in directories

## Next Steps

1. **Explore more pytest features** (fixtures, parametrization, markers)
2. **Try different debugging scenarios** (remote debugging, testing debugging)
3. **Customize key mappings** in your Neovim config
4. **Add more Python tools** (mypy, bandit, etc.)
5. **Integrate with version control** (git, commit hooks)