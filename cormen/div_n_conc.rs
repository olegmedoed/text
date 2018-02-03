/// 2T(n/2) + O(n)   => n*lg_n
/// 4T(n/2) + O(n)   => n*2^lg_n = n*n
/// 8t(n/2) + O(n*n) => n*n*n    ***
/// 8t(n/2) + O(n)   => n*4^lg_n  (bytheway: n*4^lg_n  >  n^3)
/// T(n-1)  + O(n)   => n^2 / 2
/// 2T(n-1) + O(n)   => 2^n
/// *** since every next level 8*(n/2)^2 = 2*n^2, but if O(n) => every next 
/// level 8*(n/2) = 4n

enum State { FindTop, FindBottom, }

fn find_sum_subarr(a: &[i32]) -> i32 {
    let mut state = State::FindTop;
    let mut next = 0usize;
    let (mut sum, mut total_sum, mut level) = (0, 0, 0);

    while next < a.len() {
        match state {
            State::FindTop => {
                if (sum + a[next]) > sum {
                    level += a[next];
                    sum += a[next];
                    next += 1;
                } else {
                    if total_sum < sum { total_sum = sum }
                    if total_sum < level { total_sum = level }
                    sum = 0;
                    state = State::FindBottom;
                }
            }
            State::FindBottom => {
                if (sum + a[next]) <= sum {
                    level += a[next];
                    sum += a[next];
                    next += 1;
                } else {
                    if level < 0 { level = 0 }
                    sum = 0;
                    state = State::FindTop;
                }
            }
        }
    }

    total_sum
}

fn main() {
    let a = [3, -2, -1, 5, 2, 1, -3, 5];
    println!("res is {}", find_sum_subarr(&a));
}
