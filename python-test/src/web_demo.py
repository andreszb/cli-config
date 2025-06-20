"""
Web API demonstration using requests library.

This module demonstrates:
- HTTP requests
- JSON API handling
- Error handling
- Async-like patterns
- Real-world API integration
"""

import requests
from typing import Dict, List, Optional, Any
import logging
import time

logger = logging.getLogger(__name__)


class APIClient:
    """Simple API client for demonstration."""
    
    def __init__(self, base_url: str, timeout: int = 10) -> None:
        """
        Initialize API client.
        
        Args:
            base_url: Base URL for the API
            timeout: Request timeout in seconds
        """
        self.base_url = base_url.rstrip('/')
        self.timeout = timeout
        self.session = requests.Session()
        logger.info(f"APIClient initialized with base_url: {base_url}")
    
    def get(self, endpoint: str, params: Optional[Dict[str, Any]] = None) -> Optional[Dict[str, Any]]:
        """
        Make GET request to API endpoint.
        
        Args:
            endpoint: API endpoint
            params: Query parameters
            
        Returns:
            Response data or None if error
        """
        try:
            url = f"{self.base_url}/{endpoint.lstrip('/')}"
            response = self.session.get(url, params=params, timeout=self.timeout)
            response.raise_for_status()
            
            data = response.json()
            logger.info(f"GET {endpoint} - Status: {response.status_code}")
            return data
        
        except requests.exceptions.RequestException as e:
            logger.error(f"Request error for GET {endpoint}: {e}")
            return None
        except ValueError as e:
            logger.error(f"JSON decode error for GET {endpoint}: {e}")
            return None
    
    def post(self, endpoint: str, data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Make POST request to API endpoint.
        
        Args:
            endpoint: API endpoint
            data: Data to send
            
        Returns:
            Response data or None if error
        """
        try:
            url = f"{self.base_url}/{endpoint.lstrip('/')}"
            response = self.session.post(url, json=data, timeout=self.timeout)
            response.raise_for_status()
            
            result = response.json()
            logger.info(f"POST {endpoint} - Status: {response.status_code}")
            return result
        
        except requests.exceptions.RequestException as e:
            logger.error(f"Request error for POST {endpoint}: {e}")
            return None
        except ValueError as e:
            logger.error(f"JSON decode error for POST {endpoint}: {e}")
            return None


class GitHubAPI:
    """GitHub API client demonstration."""
    
    def __init__(self) -> None:
        """Initialize GitHub API client."""
        self.client = APIClient("https://api.github.com")
    
    def get_user_info(self, username: str) -> Optional[Dict[str, Any]]:
        """
        Get GitHub user information.
        
        Args:
            username: GitHub username
            
        Returns:
            User information or None if error
        """
        return self.client.get(f"users/{username}")
    
    def get_user_repos(self, username: str, limit: int = 10) -> Optional[List[Dict[str, Any]]]:
        """
        Get user's public repositories.
        
        Args:
            username: GitHub username
            limit: Maximum number of repos to fetch
            
        Returns:
            List of repositories or None if error
        """
        params = {"per_page": limit, "sort": "updated"}
        return self.client.get(f"users/{username}/repos", params=params)
    
    def search_repositories(self, query: str, limit: int = 10) -> Optional[Dict[str, Any]]:
        """
        Search GitHub repositories.
        
        Args:
            query: Search query
            limit: Maximum number of results
            
        Returns:
            Search results or None if error
        """
        params = {"q": query, "per_page": limit, "sort": "stars"}
        return self.client.get("search/repositories", params=params)


class JSONPlaceholderAPI:
    """JSONPlaceholder API client for testing."""
    
    def __init__(self) -> None:
        """Initialize JSONPlaceholder API client."""
        self.client = APIClient("https://jsonplaceholder.typicode.com")
    
    def get_posts(self, limit: Optional[int] = None) -> Optional[List[Dict[str, Any]]]:
        """
        Get all posts.
        
        Args:
            limit: Maximum number of posts
            
        Returns:
            List of posts or None if error
        """
        posts = self.client.get("posts")
        if posts and limit:
            return posts[:limit]
        return posts
    
    def get_post(self, post_id: int) -> Optional[Dict[str, Any]]:
        """
        Get specific post.
        
        Args:
            post_id: Post ID
            
        Returns:
            Post data or None if error
        """
        return self.client.get(f"posts/{post_id}")
    
    def create_post(self, title: str, body: str, user_id: int = 1) -> Optional[Dict[str, Any]]:
        """
        Create a new post.
        
        Args:
            title: Post title
            body: Post body
            user_id: User ID
            
        Returns:
            Created post data or None if error
        """
        data = {
            "title": title,
            "body": body,
            "userId": user_id
        }
        return self.client.post("posts", data)


def demo_github_api() -> None:
    """Demonstrate GitHub API usage."""
    print("=== GitHub API Demo ===")
    
    github = GitHubAPI()
    
    # Get user info
    user_info = github.get_user_info("torvalds")
    if user_info:
        print(f"User: {user_info['name']} (@{user_info['login']})")
        print(f"Public repos: {user_info['public_repos']}")
        print(f"Followers: {user_info['followers']}")
    
    # Search repositories
    search_results = github.search_repositories("python machine learning", limit=3)
    if search_results and 'items' in search_results:
        print(f"\nTop Python ML repositories:")
        for repo in search_results['items']:
            print(f"- {repo['full_name']} (⭐ {repo['stargazers_count']})")


def demo_jsonplaceholder_api() -> None:
    """Demonstrate JSONPlaceholder API usage."""
    print("\n=== JSONPlaceholder API Demo ===")
    
    api = JSONPlaceholderAPI()
    
    # Get posts
    posts = api.get_posts(limit=3)
    if posts:
        print("Recent posts:")
        for post in posts:
            print(f"- {post['title'][:50]}...")
    
    # Create a post
    new_post = api.create_post(
        title="Test Post from Python",
        body="This is a test post created from Python code!"
    )
    if new_post:
        print(f"\nCreated post with ID: {new_post['id']}")


def benchmark_requests() -> None:
    """Benchmark API request performance."""
    print("\n=== Request Benchmark ===")
    
    api = JSONPlaceholderAPI()
    
    # Single request
    start_time = time.time()
    post = api.get_post(1)
    single_time = time.time() - start_time
    
    if post:
        print(f"Single request time: {single_time:.3f}s")
    
    # Multiple requests
    start_time = time.time()
    posts = api.get_posts(limit=5)
    multiple_time = time.time() - start_time
    
    if posts:
        print(f"Multiple posts request time: {multiple_time:.3f}s")
        print(f"Average per post: {multiple_time/len(posts):.3f}s")


if __name__ == "__main__":
    # Configure logging for demo
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    
    try:
        demo_github_api()
        demo_jsonplaceholder_api()
        benchmark_requests()
    except KeyboardInterrupt:
        print("\nDemo interrupted by user")
    except Exception as e:
        print(f"Demo error: {e}")
        logger.exception("Demo failed")