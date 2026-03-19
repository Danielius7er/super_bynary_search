const std = @import("std");
const testing = std.testing;

/// Realiza busca binária em array ordenado
/// Retorna índice do elemento ou null se não encontrado
/// Complexidade: O(log n)
pub fn binarySearch(comptime T: type, array: []const T, target: T) ?usize {
    if (array.len == 0) {
        return null;
    }

    var left: usize = 0;
    var right: usize = array.len;

    while (left < right) {
        const mid = left + (right - left) / 2;

        if (array[mid] == target) {
            return mid;
        } else if (array[mid] < target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }

    return null;
}

/// Busca o primeiro elemento >= target
pub fn lowerBound(comptime T: type, array: []const T, target: T) usize {
    var left: usize = 0;
    var right: usize = array.len;

    while (left < right) {
        const mid = left + (right - left) / 2;

        if (array[mid] < target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }

    return left;
}

/// Busca o primeiro elemento > target
pub fn upperBound(comptime T: type, array: []const T, target: T) usize {
    var left: usize = 0;
    var right: usize = array.len;

    while (left < right) {
        const mid = left + (right - left) / 2;

        if (array[mid] <= target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }

    return left;
}

/// Ordena array usando merge sort (O(n log n))
pub fn mergeSort(comptime T: type, allocator: std.mem.Allocator, array: []T) !void {
    if (array.len <= 1) {
        return;
    }

    const mid = array.len / 2;
    try mergeSort(T, allocator, array[0..mid]);
    try mergeSort(T, allocator, array[mid..]);

    var temp = try allocator.alloc(T, array.len);
    defer allocator.free(temp);

    var i: usize = 0;
    var j: usize = mid;
    var k: usize = 0;

    while (i < mid and j < array.len) : (k += 1) {
        if (array[i] <= array[j]) {
            temp[k] = array[i];
            i += 1;
        } else {
            temp[k] = array[j];
            j += 1;
        }
    }

    while (i < mid) : (i += 1) {
        temp[k] = array[i];
        k += 1;
    }

    while (j < array.len) : (j += 1) {
        temp[k] = array[j];
        k += 1;
    }

    @memcpy(array[0..array.len], temp[0..array.len]);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    _ = allocator; // Diz ao compilador: "Eu sei que não estou a usar isto, ignora"

    const array = [_]i32{ 2, 5, 8, 12, 16, 23, 38, 45, 56, 67, 78 };

    std.debug.print("Array original: {any}\n", .{array});
    
    if (binarySearch(i32, &array, 23)) |idx| {
        std.debug.print("Valor 23 encontrado no índice: {}\n", .{idx});
    } else {
        std.debug.print("Valor 23 não encontrado\n", .{});
    }

    if (binarySearch(i32, &array, 100)) |_| {
        std.debug.print("Valor 100 encontrado\n", .{});
    } else {
        std.debug.print("Valor 100 não encontrado (esperado)\n", .{});
    }
}

// Tests
test "binarySearch encontra elemento existente" {
    const array = [_]i32{ 2, 5, 8, 12, 16, 23, 38, 45, 56, 67, 78 };
    
    try testing.expectEqual(@as(?usize, 5), binarySearch(i32, &array, 23));
    try testing.expectEqual(@as(?usize, 0), binarySearch(i32, &array, 2));
    try testing.expectEqual(@as(?usize, 10), binarySearch(i32, &array, 78));
}

test "binarySearch retorna null para elemento inexistente" {
    const array = [_]i32{ 2, 5, 8, 12, 16, 23, 38, 45, 56, 67, 78 };
    
    try testing.expectEqual(@as(?usize, null), binarySearch(i32, &array, 100));
    try testing.expectEqual(@as(?usize, null), binarySearch(i32, &array, 1));
}

test "binarySearch com array vazio" {
    const array: [0]i32 = undefined;
    
    try testing.expectEqual(@as(?usize, null), binarySearch(i32, &array, 5));
}

test "lowerBound encontra primeiro elemento >= target" {
    const array = [_]i32{ 2, 5, 5, 5, 12, 16, 23, 38, 45, 56, 67, 78 };
    
    try testing.expectEqual(@as(usize, 1), lowerBound(i32, &array, 5));
    try testing.expectEqual(@as(usize, 4), lowerBound(i32, &array, 8));
    try testing.expectEqual(@as(usize, 12), lowerBound(i32, &array, 100));
}

test "upperBound encontra primeiro elemento > target" {
    const array = [_]i32{ 2, 5, 5, 5, 12, 16, 23, 38, 45, 56, 67, 78 };
    
    try testing.expectEqual(@as(usize, 4), upperBound(i32, &array, 5));
    try testing.expectEqual(@as(usize, 4), upperBound(i32, &array, 3));
}

test "mergeSort ordena array corretamente" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    
    var array = [_]i32{ 64, 34, 25, 12, 22, 11, 90 };
    try mergeSort(i32, gpa.allocator(), &array);
    
    const expected = [_]i32{ 11, 12, 22, 25, 34, 64, 90 };
    try testing.expectEqualSlices(i32, &expected, &array);
}