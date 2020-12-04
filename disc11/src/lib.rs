// Discussion 12 exercises

// You can test and play around with your code on https://play.rust-lang.org/

use std::collections::HashMap;

// Returns the sum of the even integers in the range [i, j).
// sum_evens(0, 6) -> 6 (0 + 2 + 4)
pub fn sum_evens(i: i32, j: i32) -> i32 {
    todo!()
}

// Returns the Euclidean distance between 2-dimensional points a and b.
// The points are represented as 2-tuples of f64s.
// distance((0.0, 0.0), (1.0, 1.0) -> 1.41...
// sqrt((bx-ax)^2+(by-ay)^2)
// num.powi(n) (num^n) num.sqrt()
pub fn distance((ax, ay): (f64, f64), (bx, by): (f64, f64)) -> f64 {
    todo!()
}


// Returns the sum of the squared elements of arr.
// sum_squares(&[1, 2] -> 5 (1^2 + 2^2) //
pub fn sum_squares(arr: &[i32]) -> i32 {
    todo!()
}


// Adds 1 to each element of the array. (Mutates the array.)
// let mut arr: [i32; 3] = [0, 1, 2];
// raise_1(&mut arr)
// (arr is now [1, 2, 3])
pub fn raise_1(arr: &mut [i32]) {
    todo!()
}

// Given an input array of strings, return a HashMap of the counts of each string occurence
// count_occ(["a", "a", "b", "c", "c", "c"]) returns:
// {"a" => 2, "b" => 1, "c" => 3}
pub fn count_occ<'a>(arr: &[&'a String]) -> HashMap<&'a String, i32> {
    todo!()
}

// Find and return the string that occurs the most in arr 
//highest_occ(["a", "a", "b", "c", "c", "c"])
// returns "c"
// assume the list is nonempty
pub fn highest_occ<'a> (arr: &[&'a String]) -> &'a String {
    todo!()
}

// Returns the max consecutive 1s in the array.
// consecutive_1s(&[1, 1, 1, 0, 1, 1]) -> 3
pub fn consecutive_1s(arr: &[i32]) -> i32 {
    todo!()
}
