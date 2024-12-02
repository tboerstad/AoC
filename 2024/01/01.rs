use std::fs;

fn main() {
    let contents = fs::read_to_string("./input.txt").expect("Failed to read file");

    let (mut x_coords, mut y_coords): (Vec<i32>, Vec<i32>) = contents
        .lines()
        .filter_map(|line| {
            let mut nums = line
                .split_whitespace()
                .filter_map(|num| num.parse::<i32>().ok());
            let a = nums.next()?;
            let b = nums.next()?;
            Some((a, b))
        })
        .unzip();

    x_coords.sort();
    y_coords.sort();

    let part1 = x_coords
        .iter()
        .zip(y_coords.iter())
        .map(|(a, b)| (a - b).abs())
        .sum::<i32>();
    println!("Part 1: {:?}", part1);

    let part2 = x_coords
        .iter()
        .map(|a| y_coords.iter().filter(|&b| a == b).count() * (*a) as usize)
        .sum::<usize>();
    println!("Part 2: {:?}", part2);
}
