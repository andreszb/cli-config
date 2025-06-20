"""
Example file for demonstrating debugging in Neovim.

This file contains intentional bugs and breakpoints for debugging practice.
"""

from src.calculator import Calculator
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)


def buggy_function(numbers):
    """A function with an intentional bug for debugging."""
    total = 0
    for i, num in enumerate(numbers):
        logger.debug(f"Processing number {i}: {num}")
        
        # Intentional bug: division by zero when i == 3
        if i == 3:
            result = num / 0  # This will cause an error
        else:
            result = num * 2
        
        total += result
        logger.debug(f"Running total: {total}")
    
    return total


def complex_calculation():
    """A complex calculation for step-through debugging."""
    calc = Calculator()
    
    # Set breakpoint here to step through
    numbers = [1, 2, 3, 4, 5]
    results = []
    
    for i, num in enumerate(numbers):
        logger.info(f"Processing number {i+1}: {num}")
        
        # Various calculations
        squared = calc.power(num, 2)
        doubled = calc.multiply(num, 2)
        
        if num % 2 == 0:
            result = calc.add(squared, doubled)
        else:
            result = calc.subtract(squared, doubled)
        
        results.append(result)
        logger.info(f"Result for {num}: {result}")
    
    return results


def fibonacci_debug(n):
    """Fibonacci with debugging support."""
    logger.debug(f"Computing Fibonacci for n={n}")
    
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    
    sequence = [0, 1]
    
    for i in range(2, n):
        # Set breakpoint here to watch sequence grow
        next_val = sequence[i-1] + sequence[i-2]
        sequence.append(next_val)
        logger.debug(f"Added {next_val} to sequence, length now {len(sequence)}")
    
    return sequence


def conditional_breakpoint_example():
    """Example for conditional breakpoints."""
    calc = Calculator()
    
    for i in range(1, 11):
        result = calc.power(i, 2)
        
        # Good place for conditional breakpoint: i == 5
        if result > 20:
            logger.warning(f"Large result: {i}^2 = {result}")
        
        logger.info(f"{i}^2 = {result}")


def variable_inspection_example():
    """Example for inspecting variables during debugging."""
    data = {
        'name': 'Debug Session',
        'values': [1, 2, 3, 4, 5],
        'metadata': {
            'created': '2024-01-01',
            'version': 1.0
        }
    }
    
    calc = Calculator()
    
    # Process the data
    processed_values = []
    for value in data['values']:
        # Good breakpoint location to inspect 'value' and 'processed_values'
        processed = calc.multiply(value, data['metadata']['version'])
        processed_values.append(processed)
    
    data['processed'] = processed_values
    
    # Another good breakpoint to inspect final 'data' structure
    logger.info(f"Processed {len(processed_values)} values")
    return data


if __name__ == "__main__":
    print("=== Debugging Examples ===")
    
    # Example 1: Simple calculation (good for basic debugging)
    print("\n1. Complex calculation:")
    try:
        results = complex_calculation()
        print(f"Results: {results}")
    except Exception as e:
        print(f"Error in complex_calculation: {e}")
    
    # Example 2: Fibonacci (good for step-through debugging)
    print("\n2. Fibonacci sequence:")
    fib_result = fibonacci_debug(8)
    print(f"Fibonacci(8): {fib_result}")
    
    # Example 3: Conditional breakpoints
    print("\n3. Conditional breakpoint example:")
    conditional_breakpoint_example()
    
    # Example 4: Variable inspection
    print("\n4. Variable inspection:")
    result_data = variable_inspection_example()
    print(f"Final data keys: {result_data.keys()}")
    
    # Example 5: Intentional error (debugging errors)
    print("\n5. Buggy function (will cause error):")
    try:
        buggy_result = buggy_function([1, 2, 3, 4, 5])
        print(f"Buggy result: {buggy_result}")
    except Exception as e:
        print(f"Caught error: {e}")
        logger.exception("Error in buggy_function")