{
  pkgs,
}: let
  # Python with essential packages for development
  pythonWithPackages = pkgs.python3.withPackages (ps: with ps; [
    # Core development tools
    pip
    setuptools
    wheel
    virtualenv
    
    # Code quality and formatting
    black
    isort
    flake8
    mypy
    pylint
    
    # Testing
    pytest
    pytest-cov
    
    # Popular libraries
    requests
    pyyaml
    click
    rich
    
    # Development utilities
    ipython
    
    # Package management
    pipx
  ]);
in {
  package = [
    pythonWithPackages
    pkgs.python3Packages.pip-tools  # pip-compile, pip-sync
    pkgs.ruff  # Fast Python linter and formatter
    pkgs.pyright  # Python language server
    pkgs.uv  # Fast Python package installer and resolver
  ];

  homeManagerConfig = {
    # Python-specific home manager config can be added here if needed
  };
}