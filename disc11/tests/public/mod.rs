extern crate disc11;

use std::collections::HashMap;

use disc11::*;

#[test]
fn public_test_sum_evens() {
    assert_eq!(6, sum_evens(0, 5));
    assert_eq!(18, sum_evens(4, 10));
    assert_eq!(0, sum_evens(4, 0));
}

#[test]
fn public_test_distance() {
    assert_eq!(0.0, distance((0.0, 0.0), (0.0, 0.0)));
    assert_eq!(1.0, distance((1.0, 2.0), (2.0, 2.0)));
}

#[test]
fn public_test_sum_squares() {
    assert_eq!(0, sum_squares(&[]));
    assert_eq!(14, sum_squares(&[1, 2, 3]));
}

#[test]
fn public_test_raise_1() {
    let mut arr: [i32; 3] = [0, 1, 2];
    raise_1(&mut arr);
    assert_eq!([1, 2, 3], arr);
}

#[test]
fn public_test_consecutive_1s() {
    assert_eq!(0, consecutive_1s(&[]));
    assert_eq!(3, consecutive_1s(&[1, 1, 1, 0, 1, 1]));
}


#[test]
fn public_test_hash() {
    let a = "a".to_string();
    let b = "b".to_string();
    let c = "c".to_string();
    let arr  = [&a, &a, &b, &a, &c, &b, &c, &c, &a, &a, &c];
    let mut out_hash = HashMap::new();
    out_hash.insert(&a, 5);
    out_hash.insert(&b, 2);
    out_hash.insert(&c, 4);
    assert_eq!(out_hash, count_occ(&arr));
    assert_eq!(&a, highest_occ(&arr));
}
