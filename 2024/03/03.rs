use regex::Regex;

fn calculate_multiplication_sum(input: &str, sum: i32) -> i32 {
    let re = Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)").unwrap();
    re.captures_iter(input).fold(sum, |acc, cap| {
        let a: i32 = cap[1].parse().unwrap();
        let b: i32 = cap[2].parse().unwrap();
        acc + (a * b)
    })
}
fn main() {
    let contents = include_str!("ex2.txt");

    println!("{}", calculate_multiplication_sum(contents, 0));

    let mut capturing = true;
    let mut sum2 = 0;
    let mut start_idx = 0;

    while start_idx < contents.len() {
        if capturing {
            let end_idx = contents[start_idx..]
                .find("don't()")
                .unwrap_or(contents.len() - start_idx)
                + start_idx;
            sum2 = calculate_multiplication_sum(&contents[start_idx..end_idx], sum2);
            start_idx = end_idx + "don't()".len() + 1;
            capturing = false;
        } else {
            start_idx = contents[start_idx..].find("do()").unwrap_or(contents.len()) + start_idx;
            capturing = true;
        }
    }

    let sum2: i32 = contents
        .split("do()")
        .map(|segment| {
            let relevant_part = segment.split("don't()").next().unwrap();
            calculate_multiplication_sum(relevant_part, 0)
        })
        .sum();

    println!("{}", sum2);
}

"abc do() sdfa dont() asdfff do()"