int fact(int n) {
    int res = n;
    int i;
    for(i = n-1; i>1; --i)
        res *= i;
    return res;
}

int main () {
    return fact(5);
}
