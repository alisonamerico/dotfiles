# Stubs for email.feedparser (Python 3.4)

from email.message import Message
from email.policy import Policy
from typing import Callable

class FeedParser:
    def __init__(self, _factory: Callable[[], Message] = ..., *, policy: Policy = ...) -> None: ...
    def feed(self, data: str) -> None: ...
    def close(self) -> Message: ...

class BytesFeedParser:
    def __init__(self, _factory: Callable[[], Message] = ..., *, policy: Policy = ...) -> None: ...
    def feed(self, data: bytes) -> None: ...
    def close(self) -> Message: ...