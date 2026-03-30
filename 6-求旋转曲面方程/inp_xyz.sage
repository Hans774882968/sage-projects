load('6-求旋转曲面方程/compute.sage')

print("=" * 50)
print("Hans7 的旋转曲面求解器")
print("=" * 50)

var('t s')
print("\n请输入曲线的参数方程 (变量为 x, y, z):")
try:
    c1 = SR(input("f(x, y, z) = "))
    c2 = SR(input("g(x, y, z) = "))
    curve = [c1, c2]

    print("\n请输入直线的参数方程 (变量为 t):")
    lx = SR(input("x(t) = "))
    ly = SR(input("y(t) = "))
    lz = SR(input("z(t) = "))
    line = [lx, ly, lz]
except Exception as e:
    print(f"输入解析错误：{e}")
    print("提示：请确保输入合法的 Sage 表达式")
    exit(1)

print(f"\n输入曲线：{curve}")
print(f"输入直线：{line}")
print("-" * 30)

try:
    result_poly = compute_surface_of_revolution_xyz(curve, line)
    print("-" * 30)
    print("计算完成！曲面方程 f(x,y,z) = 0 为：")
    print(f"{result_poly} = 0")
    print("\n(注：若结果包含常数因子，不影响方程几何意义)")

except Exception as e:
    print(f"发生错误：{e}")
    print("请检查输入方程是否为多项式形式，且系数是否兼容。")
