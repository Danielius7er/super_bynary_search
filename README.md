# Binary Search Implementation in Zig

A clean, efficient implementation of the binary search algorithm written in Zig.

## Overview

This project demonstrates binary search, a fundamental algorithm for finding a target value in a sorted array with O(log n) time complexity.

## Features

- Efficient binary search implementation
- Works with sorted arrays
- Logarithmic time complexity
- Written in Zig for performance and safety

## Usage

```zig
const result = binarySearch(array, target);
```

## Building

```bash
zig build
```

## Running

```bash
zig build run
```

## Algorithm

Binary search divides the search interval in half repeatedly until the target is found or the interval is empty.

## Requirements

- Zig 0.11 or later

## License

MIT
