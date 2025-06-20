"""
Pytest configuration and shared fixtures.
"""

import pytest
import logging
import sys
from pathlib import Path

# Add src directory to Python path so we can import modules
sys.path.insert(0, str(Path(__file__).parent / "src"))


def pytest_configure(config):
    """Configure pytest settings."""
    # Add custom markers
    config.addinivalue_line(
        "markers", "slow: marks tests as slow (deselect with '-m \"not slow\"')"
    )
    
    # Configure logging for tests
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )


@pytest.fixture(scope="session")
def test_data_dir():
    """Provide path to test data directory."""
    return Path(__file__).parent / "data"


@pytest.fixture
def sample_numbers():
    """Provide sample numbers for testing."""
    return [1.5, 2.3, 4.7, 3.1, 5.9, 2.8, 4.2, 3.6, 1.9, 5.1]


@pytest.fixture
def sample_user_data():
    """Provide sample user data for testing."""
    return [
        {"id": 1, "name": "Alice", "age": 30, "active": True},
        {"id": 2, "name": "Bob", "age": 25, "active": False},
        {"id": 3, "name": "Charlie", "age": 35, "active": True},
    ]


@pytest.fixture(autouse=True)
def setup_test_environment():
    """Set up test environment for each test."""
    # This fixture runs automatically for every test
    # Can be used to set up common test state
    
    # Suppress request warnings during tests
    import urllib3
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    
    yield
    
    # Cleanup after test if needed
    pass


def pytest_collection_modifyitems(config, items):
    """Modify test collection to add markers."""
    # Automatically mark tests that take longer as slow
    for item in items:
        if "large" in item.name or "benchmark" in item.name:
            item.add_marker(pytest.mark.slow)