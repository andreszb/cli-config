"""
Data processing module demonstrating file I/O and data manipulation.

This module shows:
- File operations
- JSON handling
- Data validation
- Exception handling
- Context managers
"""

import json
import csv
from pathlib import Path
from typing import Dict, List, Any, Optional
import logging

logger = logging.getLogger(__name__)


class DataProcessor:
    """Process and manipulate data from various sources."""
    
    def __init__(self, data_dir: str = "data") -> None:
        """
        Initialize data processor.
        
        Args:
            data_dir: Directory to store data files
        """
        self.data_dir = Path(data_dir)
        self.data_dir.mkdir(exist_ok=True)
        logger.info(f"DataProcessor initialized with data_dir: {self.data_dir}")
    
    def save_json(self, data: Dict[str, Any], filename: str) -> bool:
        """
        Save data to JSON file.
        
        Args:
            data: Data to save
            filename: Name of the file
            
        Returns:
            True if successful, False otherwise
        """
        try:
            file_path = self.data_dir / f"{filename}.json"
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            logger.info(f"Data saved to {file_path}")
            return True
        except Exception as e:
            logger.error(f"Error saving JSON: {e}")
            return False
    
    def load_json(self, filename: str) -> Optional[Dict[str, Any]]:
        """
        Load data from JSON file.
        
        Args:
            filename: Name of the file
            
        Returns:
            Loaded data or None if error
        """
        try:
            file_path = self.data_dir / f"{filename}.json"
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            logger.info(f"Data loaded from {file_path}")
            return data
        except FileNotFoundError:
            logger.warning(f"File not found: {filename}.json")
            return None
        except json.JSONDecodeError as e:
            logger.error(f"JSON decode error: {e}")
            return None
        except Exception as e:
            logger.error(f"Error loading JSON: {e}")
            return None
    
    def save_csv(self, data: List[Dict[str, Any]], filename: str) -> bool:
        """
        Save data to CSV file.
        
        Args:
            data: List of dictionaries to save
            filename: Name of the file
            
        Returns:
            True if successful, False otherwise
        """
        if not data:
            logger.warning("No data to save")
            return False
        
        try:
            file_path = self.data_dir / f"{filename}.csv"
            fieldnames = data[0].keys()
            
            with open(file_path, 'w', newline='', encoding='utf-8') as f:
                writer = csv.DictWriter(f, fieldnames=fieldnames)
                writer.writeheader()
                writer.writerows(data)
            
            logger.info(f"CSV data saved to {file_path}")
            return True
        except Exception as e:
            logger.error(f"Error saving CSV: {e}")
            return False
    
    def load_csv(self, filename: str) -> Optional[List[Dict[str, Any]]]:
        """
        Load data from CSV file.
        
        Args:
            filename: Name of the file
            
        Returns:
            List of dictionaries or None if error
        """
        try:
            file_path = self.data_dir / f"{filename}.csv"
            data = []
            
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                data = list(reader)
            
            logger.info(f"CSV data loaded from {file_path}")
            return data
        except FileNotFoundError:
            logger.warning(f"File not found: {filename}.csv")
            return None
        except Exception as e:
            logger.error(f"Error loading CSV: {e}")
            return None
    
    def analyze_numbers(self, numbers: List[float]) -> Dict[str, float]:
        """
        Analyze a list of numbers.
        
        Args:
            numbers: List of numbers to analyze
            
        Returns:
            Dictionary with statistics
        """
        if not numbers:
            return {}
        
        result = {
            'count': len(numbers),
            'sum': sum(numbers),
            'mean': sum(numbers) / len(numbers),
            'min': min(numbers),
            'max': max(numbers),
        }
        
        # Calculate median
        sorted_nums = sorted(numbers)
        n = len(sorted_nums)
        if n % 2 == 0:
            result['median'] = (sorted_nums[n//2 - 1] + sorted_nums[n//2]) / 2
        else:
            result['median'] = sorted_nums[n//2]
        
        logger.info("Number analysis completed")
        return result


def create_sample_data() -> Dict[str, Any]:
    """Create sample data for testing."""
    import random
    from datetime import datetime, timedelta
    
    # Generate sample data
    start_date = datetime.now() - timedelta(days=30)
    
    sample_data = {
        'metadata': {
            'created': datetime.now().isoformat(),
            'description': 'Sample data for testing Python development',
            'version': '1.0'
        },
        'users': [
            {
                'id': i,
                'name': f'User{i}',
                'email': f'user{i}@example.com',
                'score': random.randint(0, 100),
                'active': random.choice([True, False]),
                'join_date': (start_date + timedelta(days=random.randint(0, 30))).isoformat()
            }
            for i in range(1, 21)
        ],
        'statistics': {
            'total_users': 20,
            'active_users': len([u for u in [] if random.choice([True, False])]),
            'average_score': 0  # Will be calculated
        }
    }
    
    # Calculate actual statistics
    scores = [user['score'] for user in sample_data['users']]
    sample_data['statistics']['average_score'] = sum(scores) / len(scores)
    sample_data['statistics']['active_users'] = len([u for u in sample_data['users'] if u['active']])
    
    return sample_data


if __name__ == "__main__":
    # Demo the data processor
    processor = DataProcessor()
    
    print("=== Data Processor Demo ===")
    
    # Create and save sample data
    sample_data = create_sample_data()
    processor.save_json(sample_data, 'sample_data')
    
    # Load and display data
    loaded_data = processor.load_json('sample_data')
    if loaded_data:
        print(f"Loaded data with {len(loaded_data['users'])} users")
        print(f"Average score: {loaded_data['statistics']['average_score']:.2f}")
    
    # Create CSV data
    csv_data = [
        {'name': 'Alice', 'age': 30, 'city': 'New York'},
        {'name': 'Bob', 'age': 25, 'city': 'San Francisco'},
        {'name': 'Charlie', 'age': 35, 'city': 'Chicago'},
    ]
    processor.save_csv(csv_data, 'users')
    
    # Analyze some numbers
    numbers = [1.5, 2.3, 4.7, 3.1, 5.9, 2.8, 4.2, 3.6, 1.9, 5.1]
    analysis = processor.analyze_numbers(numbers)
    print(f"\nNumber Analysis: {analysis}")