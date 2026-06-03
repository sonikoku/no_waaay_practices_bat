def add(a, b):
    return a + b
 
 
def format_task(title, status="new"):
    return f"[{status.upper()}] {title}"
 
 
def main():
    print("Demo project started")
    print(format_task("Проверить BAT-файлы", "done"))
    print("2 + 3 =", add(2, 3))
 
 
if __name__ == "__main__":
    main()