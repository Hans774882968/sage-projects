load('6-求旋转曲面方程/compute.sage')

print("=" * 50)
print("Hans7 的旋转曲面求解器")
print("=" * 50)

var('t s')
print("\n请输入曲线的参数方程 (变量为 t):")
try:
    cx = SR(input("x(t) = "))
    cy = SR(input("y(t) = "))
    cz = SR(input("z(t) = "))
    curve = [cx, cy, cz]

    print("\n请输入直线的参数方程 (变量为 s):")
    lx = SR(input("x(s) = "))
    ly = SR(input("y(s) = "))
    lz = SR(input("z(s) = "))
    line = [lx, ly, lz]
except Exception as e:
    print(f"输入解析错误：{e}")
    print("提示：请确保输入合法的 Sage 表达式")
    exit(1)

print(f"\n输入曲线：{curve}")
print(f"输入直线：{line}")
print("-" * 30)

try:
    result_poly = compute_surface_of_revolution(curve, line)
    print("-" * 30)
    print("计算完成！曲面方程 f(x,y,z) = 0 为：")
    print(f"{result_poly} = 0")
    print("\n(注：若结果包含常数因子，不影响方程几何意义)")

except Exception as e:
    print(f"发生错误：{e}")
    print("请检查输入方程是否为多项式形式，且系数是否兼容。")
