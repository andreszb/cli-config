"""
Tests for the calculator module.

This demonstrates pytest usage and testing patterns.
"""

import pytest
from src.calculator import Calculator, factorial, fibonacci


class TestCalculator:
    """Test class for Calculator."""
    
    def setup_method(self):
        """Set up test fixtures before each test method."""
        self.calc = Calculator()
    
    def test_add(self):
        """Test addition operation."""
        assert self.calc.add(2, 3) == 5
        assert self.calc.add(-1, 1) == 0
        assert self.calc.add(0.1, 0.2) == pytest.approx(0.3)
    
    def test_subtract(self):
        """Test subtraction operation."""
        assert self.calc.subtract(5, 3) == 2
        assert self.calc.subtract(0, 5) == -5
        assert self.calc.subtract(10.5, 0.5) == 10.0
    
    def test_multiply(self):
        """Test multiplication operation."""
        assert self.calc.multiply(4, 5) == 20
        assert self.calc.multiply(-2, 3) == -6
        assert self.calc.multiply(0, 100) == 0
    
    def test_divide(self):
        """Test division operation."""
        assert self.calc.divide(10, 2) == 5
        assert self.calc.divide(7, 2) == 3.5
        assert self.calc.divide(-10, 2) == -5
    
    def test_divide_by_zero(self):
        """Test division by zero raises ValueError."""
        with pytest.raises(ValueError, match="Cannot divide by zero"):
            self.calc.divide(10, 0)
    
    def test_power(self):
        """Test power operation."""
        assert self.calc.power(2, 3) == 8
        assert self.calc.power(5, 0) == 1
        assert self.calc.power(4, 0.5) == 2
    
    def test_history_tracking(self):
        """Test that operations are tracked in history."""
        self.calc.add(2, 3)
        self.calc.multiply(4, 5)
        
        history = self.calc.get_history()
        assert len(history) == 2
        assert "2 + 3 = 5" in history
        assert "4 * 5 = 20" in history
    
    def test_clear_history(self):
        """Test clearing calculation history."""
        self.calc.add(1, 1)
        self.calc.clear_history()
        assert len(self.calc.get_history()) == 0
    
    def test_history_independence(self):
        """Test that getting history doesn't affect internal state."""
        self.calc.add(1, 1)
        history1 = self.calc.get_history()
        history2 = self.calc.get_history()
        
        # Modify one copy
        history1.append("fake operation")
        
        # Original should be unchanged
        assert len(history2) == 1
        assert len(self.calc.get_history()) == 1


class TestFactorial:
    """Test class for factorial function."""
    
    def test_factorial_base_cases(self):
        """Test factorial base cases."""
        assert factorial(0) == 1
        assert factorial(1) == 1
    
    def test_factorial_positive_numbers(self):
        """Test factorial of positive numbers."""
        assert factorial(5) == 120
        assert factorial(4) == 24
        assert factorial(3) == 6
    
    def test_factorial_negative_number(self):
        """Test factorial of negative number raises ValueError."""
        with pytest.raises(ValueError, match="Factorial is not defined for negative numbers"):
            factorial(-1)
    
    @pytest.mark.parametrize("n,expected", [
        (0, 1),
        (1, 1),
        (2, 2),
        (3, 6),
        (4, 24),
        (5, 120),
    ])
    def test_factorial_parametrized(self, n, expected):
        """Test factorial with parametrized inputs."""
        assert factorial(n) == expected


class TestFibonacci:
    """Test class for fibonacci function."""
    
    def test_fibonacci_edge_cases(self):
        """Test fibonacci edge cases."""
        assert fibonacci(0) == []
        assert fibonacci(1) == [0]
        assert fibonacci(2) == [0, 1]
    
    def test_fibonacci_sequence(self):
        """Test fibonacci sequence generation."""
        expected = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
        assert fibonacci(10) == expected
    
    def test_fibonacci_negative_input(self):
        """Test fibonacci with negative input raises ValueError."""
        with pytest.raises(ValueError, match="Number of terms cannot be negative"):
            fibonacci(-1)
    
    @pytest.mark.parametrize("n,expected_length", [
        (0, 0),
        (1, 1),
        (5, 5),
        (10, 10),
    ])
    def test_fibonacci_length(self, n, expected_length):
        """Test fibonacci sequence has correct length."""
        result = fibonacci(n)
        assert len(result) == expected_length
    
    def test_fibonacci_properties(self):
        """Test mathematical properties of fibonacci sequence."""
        sequence = fibonacci(10)
        
        # Each number (after the first two) should be sum of previous two
        for i in range(2, len(sequence)):
            assert sequence[i] == sequence[i-1] + sequence[i-2]


@pytest.fixture
def calculator_with_operations():
    """Fixture providing a calculator with some operations performed."""
    calc = Calculator()
    calc.add(10, 5)
    calc.multiply(3, 4)
    calc.divide(20, 4)
    return calc


def test_calculator_fixture(calculator_with_operations):
    """Test using the calculator fixture."""
    history = calculator_with_operations.get_history()
    assert len(history) == 3
    assert any("10 + 5 = 15" in op for op in history)


@pytest.mark.slow
def test_large_factorial():
    """Test factorial with larger numbers (marked as slow)."""
    result = factorial(10)
    assert result == 3628800


class TestCalculatorIntegration:
    """Integration tests for calculator operations."""
    
    def test_complex_calculation_sequence(self):
        """Test a complex sequence of calculations."""
        calc = Calculator()
        
        # Perform a series of operations
        result1 = calc.add(10, 5)        # 15
        result2 = calc.multiply(result1, 2)  # 30
        result3 = calc.divide(result2, 3)    # 10
        result4 = calc.power(result3, 2)     # 100
        
        assert result4 == 100
        
        # Check history contains all operations
        history = calc.get_history()
        assert len(history) == 4
    
    def test_error_handling_in_sequence(self):
        """Test error handling doesn't break subsequent operations."""
        calc = Calculator()
        
        # Successful operation
        calc.add(5, 5)
        
        # Failed operation
        with pytest.raises(ValueError):
            calc.divide(10, 0)
        
        # Subsequent operation should still work
        result = calc.multiply(3, 4)
        assert result == 12
        
        # History should contain successful operations only
        history = calc.get_history()
        assert len(history) == 2  # add and multiply, not the failed divide