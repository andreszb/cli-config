"""
Tests for the data processor module.
"""

import pytest
import json
import csv
from pathlib import Path
import tempfile
import shutil
from src.data_processor import DataProcessor, create_sample_data


class TestDataProcessor:
    """Test class for DataProcessor."""
    
    def setup_method(self):
        """Set up test fixtures."""
        # Create temporary directory for each test
        self.temp_dir = tempfile.mkdtemp()
        self.processor = DataProcessor(self.temp_dir)
    
    def teardown_method(self):
        """Clean up after each test."""
        # Remove temporary directory
        shutil.rmtree(self.temp_dir, ignore_errors=True)
    
    def test_init_creates_directory(self):
        """Test that initialization creates the data directory."""
        assert Path(self.temp_dir).exists()
        assert Path(self.temp_dir).is_dir()
    
    def test_save_and_load_json(self):
        """Test saving and loading JSON data."""
        test_data = {
            "name": "Test User",
            "age": 25,
            "active": True,
            "scores": [85, 92, 78]
        }
        
        # Save data
        success = self.processor.save_json(test_data, "test_user")
        assert success is True
        
        # Load data
        loaded_data = self.processor.load_json("test_user")
        assert loaded_data == test_data
    
    def test_load_nonexistent_json(self):
        """Test loading non-existent JSON file."""
        result = self.processor.load_json("nonexistent")
        assert result is None
    
    def test_save_invalid_json(self):
        """Test saving invalid JSON data."""
        # Create data that can't be JSON serialized
        import datetime
        invalid_data = {"date": datetime.datetime.now()}
        
        success = self.processor.save_json(invalid_data, "invalid")
        assert success is False
    
    def test_save_and_load_csv(self):
        """Test saving and loading CSV data."""
        test_data = [
            {"name": "Alice", "age": 30, "city": "New York"},
            {"name": "Bob", "age": 25, "city": "San Francisco"},
            {"name": "Charlie", "age": 35, "city": "Chicago"}
        ]
        
        # Save data
        success = self.processor.save_csv(test_data, "users")
        assert success is True
        
        # Load data
        loaded_data = self.processor.load_csv("users")
        assert loaded_data == test_data
    
    def test_save_empty_csv(self):
        """Test saving empty CSV data."""
        success = self.processor.save_csv([], "empty")
        assert success is False
    
    def test_load_nonexistent_csv(self):
        """Test loading non-existent CSV file."""
        result = self.processor.load_csv("nonexistent")
        assert result is None
    
    def test_analyze_numbers_basic(self):
        """Test basic number analysis."""
        numbers = [1, 2, 3, 4, 5]
        result = self.processor.analyze_numbers(numbers)
        
        expected = {
            'count': 5,
            'sum': 15,
            'mean': 3.0,
            'min': 1,
            'max': 5,
            'median': 3
        }
        
        assert result == expected
    
    def test_analyze_numbers_even_count(self):
        """Test number analysis with even count (median calculation)."""
        numbers = [1, 2, 3, 4]
        result = self.processor.analyze_numbers(numbers)
        
        assert result['median'] == 2.5  # (2 + 3) / 2
    
    def test_analyze_empty_numbers(self):
        """Test analyzing empty list of numbers."""
        result = self.processor.analyze_numbers([])
        assert result == {}
    
    def test_analyze_single_number(self):
        """Test analyzing single number."""
        result = self.processor.analyze_numbers([42])
        
        expected = {
            'count': 1,
            'sum': 42,
            'mean': 42,
            'min': 42,
            'max': 42,
            'median': 42
        }
        
        assert result == expected
    
    @pytest.mark.parametrize("numbers,expected_median", [
        ([1, 2, 3], 2),
        ([1, 2, 3, 4], 2.5),
        ([5, 1, 3], 3),
        ([10], 10),
    ])
    def test_median_calculation(self, numbers, expected_median):
        """Test median calculation with various inputs."""
        result = self.processor.analyze_numbers(numbers)
        assert result['median'] == expected_median


def test_create_sample_data():
    """Test sample data creation."""
    data = create_sample_data()
    
    # Check structure
    assert 'metadata' in data
    assert 'users' in data
    assert 'statistics' in data
    
    # Check metadata
    assert 'created' in data['metadata']
    assert 'version' in data['metadata']
    
    # Check users
    assert len(data['users']) == 20
    for user in data['users']:
        assert 'id' in user
        assert 'name' in user
        assert 'email' in user
        assert 'score' in user
        assert 'active' in user
        assert 'join_date' in user
        
        # Validate data types
        assert isinstance(user['id'], int)
        assert isinstance(user['score'], int)
        assert isinstance(user['active'], bool)
        assert 0 <= user['score'] <= 100
    
    # Check statistics
    stats = data['statistics']
    assert stats['total_users'] == 20
    assert 'average_score' in stats
    assert 'active_users' in stats


class TestDataProcessorIntegration:
    """Integration tests for DataProcessor."""
    
    def setup_method(self):
        """Set up test fixtures."""
        self.temp_dir = tempfile.mkdtemp()
        self.processor = DataProcessor(self.temp_dir)
    
    def teardown_method(self):
        """Clean up after each test."""
        shutil.rmtree(self.temp_dir, ignore_errors=True)
    
    def test_json_to_csv_workflow(self):
        """Test converting JSON data to CSV format."""
        # Create sample data
        sample_data = create_sample_data()
        
        # Save as JSON
        self.processor.save_json(sample_data, "sample")
        
        # Extract users and save as CSV
        users_data = sample_data['users']
        self.processor.save_csv(users_data, "users_export")
        
        # Load CSV and verify
        loaded_csv = self.processor.load_csv("users_export")
        assert len(loaded_csv) == 20
        
        # Check that data matches (CSV loads everything as strings)
        for i, user in enumerate(loaded_csv):
            original_user = users_data[i]
            assert user['name'] == original_user['name']
            assert user['email'] == original_user['email']
            assert int(user['id']) == original_user['id']
    
    def test_data_analysis_workflow(self):
        """Test complete data analysis workflow."""
        # Create and save sample data
        sample_data = create_sample_data()
        self.processor.save_json(sample_data, "analysis_data")
        
        # Load and analyze scores
        loaded_data = self.processor.load_json("analysis_data")
        scores = [user['score'] for user in loaded_data['users']]
        
        analysis = self.processor.analyze_numbers(scores)
        
        # Verify analysis results
        assert analysis['count'] == 20
        assert 0 <= analysis['mean'] <= 100
        assert 0 <= analysis['min'] <= 100
        assert 0 <= analysis['max'] <= 100
        assert analysis['min'] <= analysis['median'] <= analysis['max']
        
        # Save analysis results
        analysis_result = {
            'original_data': 'analysis_data.json',
            'analysis': analysis,
            'total_users': len(loaded_data['users'])
        }
        
        success = self.processor.save_json(analysis_result, "score_analysis")
        assert success is True
    
    def test_error_recovery(self):
        """Test that processor recovers from errors gracefully."""
        # Try to load non-existent file
        result1 = self.processor.load_json("missing")
        assert result1 is None
        
        # Processor should still work for valid operations
        test_data = {"test": "data"}
        success = self.processor.save_json(test_data, "recovery_test")
        assert success is True
        
        result2 = self.processor.load_json("recovery_test")
        assert result2 == test_data


@pytest.fixture
def sample_processor():
    """Fixture providing a DataProcessor with sample data."""
    temp_dir = tempfile.mkdtemp()
    processor = DataProcessor(temp_dir)
    
    # Add some sample data
    data = create_sample_data()
    processor.save_json(data, "fixture_data")
    
    yield processor
    
    # Cleanup
    shutil.rmtree(temp_dir, ignore_errors=True)


def test_processor_fixture(sample_processor):
    """Test using the sample processor fixture."""
    data = sample_processor.load_json("fixture_data")
    assert data is not None
    assert len(data['users']) == 20