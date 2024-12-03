#[derive(Debug)]
enum Direction {
    INCREASING,
    DECREASING,
}

fn valid_with_removal(v: &Vec<i32>) -> bool {
    for i in 0..v.len() {
        let subvector_valid = valid(
            &v[..i]
                .iter()
                .chain(&v[i + 1..])
                .copied()
                .collect::<Vec<i32>>(),
        );
        if subvector_valid {
            return true;
        }
    }
    return false;
}

fn valid(v: &Vec<i32>) -> bool {
    if v[1] == v[0] {
        return false;
    };
    let dir: Direction = if v[1] > v[0] {
        Direction::INCREASING
    } else {
        Direction::DECREASING
    };
    for i in 0..v.len() - 1 {
        match dir {
            Direction::INCREASING => {
                if v[i + 1] <= v[i] {
                    return false;
                }
            }
            Direction::DECREASING => {
                if v[i + 1] >= v[i] {
                    return false;
                }
            }
        }
        if (v[i + 1] - v[i]).abs() > 3 {
            return false;
        }
    }
    true
}

fn main() {
    let contents = include_str!("input.txt");

    let levels: Vec<Vec<i32>> = contents
        .lines()
        .map(|line| {
            line.split_whitespace()
                .filter_map(|num| num.parse().ok())
                .collect()
        })
        .collect();

    let part1 = levels.iter().filter(|&v| valid(v)).count();
    let part2 = levels.iter().filter(|&v| valid_with_removal(v)).count();

    println!("{:?}", part1);
    println!("{:?}", part2);
}
