extern int printf(const char *, ...);

int max(int a, int b) {
    return a > b ? a : b;
}

int main() {
    int a = 4;
    int b = 6;
    int c = max(a, b);
    printf("%d\n", c);

    return 0;
}
