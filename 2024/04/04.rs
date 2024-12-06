fn is_xmas(c: &[char]) -> bool {
    let forward = ['X', 'M', 'A', 'S'];
    let backward = ['S', 'A', 'M', 'X'];
    c == forward || c == backward
}

fn main() {
    let contents = include_str!("input.txt");
    let text: Vec<Vec<char>> = contents
        .lines()
        .map(|line| line.chars().collect())
        .collect();

    let m = text.len();
    let n = text[0].len();

    let mut sum = 0;

    for i in 0..m {
        for j in 0..n {
            if j + 3 < n {
                if is_xmas(&[text[i][j], text[i][j + 1], text[i][j + 2], text[i][j + 3]]) {
                    sum += 1;
                }
            }
            if i + 3 < m {
                if is_xmas(&[text[i][j], text[i + 1][j], text[i + 2][j], text[i + 3][j]]) {
                    sum += 1;
                }
            }
            if i + 3 < m && j + 3 < n {
                if is_xmas(&[
                    text[i][j],
                    text[i + 1][j + 1],
                    text[i + 2][j + 2],
                    text[i + 3][j + 3],
                ]) {
                    sum += 1;
                }
            }

            if i + 3 < m && j >= 3 {
                if is_xmas(&[
                    text[i][j],
                    text[i + 1][j - 1],
                    text[i + 2][j - 2],
                    text[i + 3][j - 3],
                ]) {
                    sum += 1;
                }
            }
        }
    }

    let mut sum2 = 0;
    for i in 0..m - 2 {
        for j in 0..n - 2 {
            let lr = (text[i][j] == 'M' && text[i + 1][j + 1] == 'A' && text[i + 2][j + 2] == 'S')
                || (text[i][j] == 'S' && text[i + 1][j + 1] == 'A' && text[i + 2][j + 2] == 'M');
            let rl = (text[i + 2][j] == 'M' && text[i + 1][j + 1] == 'A' && text[i][j + 2] == 'S')
                || (text[i + 2][j] == 'S' && text[i + 1][j + 1] == 'A' && text[i][j + 2] == 'M');
            if lr && rl {
                sum2 += 1;
            }
        }
    }

    println!("{}", sum);
    println!("{}", sum2);
}
