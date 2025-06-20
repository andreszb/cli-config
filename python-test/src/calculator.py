"""
A simple calculator module for demonstrating Python development in Neovim.

This module provides basic arithmetic operations and demonstrates:
- Type hints
- Docstrings
- Error handling
- Class structure
"""

from typing import Union, List
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Calculator:
    """A simple calculator class with history tracking."""
    
    def __init__(self) -> None:
        """Initialize the calculator with empty history."""
        self.history: List[str] = []
        logger.info("Calculator initialized")
    
    def add(self, a: Union[int, float], b: Union[int, float]) -> Union[int, float]:
        """
        Add two numbers.
        
        Args:
            a: First number
            b: Second number
            
        Returns:
            Sum of a and b
        """
        result = a + b 
        operation = f"{a} + {b} = {result}"
        self.history.append(operation)
        logger.info(f"Addition: {operation}")
        return result
    
    def subtract(self, a: Union[int, float], b: Union[int, float]) -> Union[int, float]:
        """
        Subtract two numbers.
        
        Args:
            a: First number
            b: Second number
            
        Returns:
            Difference of a and b
        """
        result = a - b
    operation = f"{a} - {b} = {result}"
        self.history.append(operation)
        logger.info(f"Subtraction: {operation}")
        return result
    
    def multiply(self, a: Union[int, float], b: Union[int, float]) -> Union[int, float]:
        """
        Multiply two numbers.
        
        Args:
            a: First number
            b: Second number
            
        Returns:
            Product of a and b
        """
        result = a * b
        operation = f"{a} * {b} = {result}"
        self.history.append(operation)
        logger.info(f"Multiplication: {operation}")
        return result
    
    def divide(self, a: Union[int, float], b: Union[int, float]) -> Union[int, float]:
        """
        Divide two numbers.
        
        Args:
            a: Dividend
            b: Divisor
            
        Returns:
            Quotient of a and b
            
        Raises:
            ValueError: If divisor is zero
        """
        if b == 0:
            error_msg = "Cannot divide by zero"
            logger.error(error_msg)
            raise ValueError(error_msg)
        
        result = a / b
        operation = f"{a} / {b} = {result}"
        self.history.append(operation)
        logger.info(f"Division: {operation}")
        return result
    
    def power(self, base: Union[int, float], exponent: Union[int, float]) -> Union[int, float]:
        """
        Raise base to the power of exponent.
        
        Args:
            base: Base number
            exponent: Exponent
            
        Returns:
            base raised to the power of exponent
        """
        result = base ** exponent
        operation = f"{base} ** {exponent} = {result}"
        self.history.append(operation)
        logger.info(f"Power: {operation}")
        return result
    
    def get_history(self) -> List[str]:
        """
        Get calculation history.
        
        Returns:
            List of calculation strings
        """
        return self.history.copy()
    
    def clear_history(self) -> None:
        """Clear calculation history."""
        self.history.clear()
        logger.info("History cleared")


def factorial(n: int) -> int:
    """
    Calculate factorial of a number.
    
    Args:
        n: Non-negative integer
        
    Returns:
        Factorial of n
        
    Raises:
        ValueError: If n is negative
    """
    if n < 0:
        raise ValueError("Factorial is not defined for negative numbers")
    
    if n == 0 or n == 1:
        return 1
    
    result = 1
    for i in range(2, n + 1):
        result *= i
    
    logger.info(f"Factorial: {n}! = {result}")
    return result


def fibonacci(n: int) -> List[int]:
    """
    Generate Fibonacci sequence up to n terms.
    
    Args:
        n: Number of terms to generate
        
    Returns:
        List of Fibonacci numbers
        
    Raises:
        ValueError: If n is negative
    """
    if n < 0:
        raise ValueError("Number of terms cannot be negative")
    
    if n == 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    
    sequence = [0, 1]
    for i in range(2, n):
        sequence.append(sequence[i-1] + sequence[i-2])
    
    logger.info(f"Generated Fibonacci sequence with {n} terms")
    return sequence


if __name__ == "__main__":
    # Demo the calculator
    calc = Calculator()
    
    print("=== Calculator Demo ===")
    print(f"5 + 3 = {calc.add(5, 3)}")
    print(f"10 - 4 = {calc.subtract(10, 4)}")
    print(f"6 * 7 = {calc.multiply(6, 7)}")
    print(f"15 / 3 = {calc.divide(15, 3)}")
    print(f"2 ** 8 = {calc.power(2, 8)}")
    
    print("\n=== History ===")
    for operation in calc.get_history():
        print(operation)
    
    print(f"\n=== Other Functions ===")
    print(f"5! = {factorial(5)}")
    print(f"Fibonacci(10) = {fibonacci(10)}")
