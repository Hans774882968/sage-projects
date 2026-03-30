import traceback

load('6-求旋转曲面方程/compute.sage')
var('t s x y z')
cases = [
    [[2 - t, 3 * t - 4, t - 1], [2 * s + 2, s + 4, 3 * s + 1]],
    [[3, 4, t], [0, 0, s]],
]
for curve, line in cases:
    print("-" * 30)
    print(f"曲线：{curve}")
    print(f"直线：{line}")
    try:
        result_poly = compute_surface_of_revolution(curve, line)
        print("-" * 30)
        print("计算完成！曲面方程 f(x,y,z) = 0 为：")
        print(f"{result_poly} = 0")
        print("\n(注：若结果包含常数因子，不影响方程几何意义)")

    except Exception as e:
        print(f"发生错误：{e}")
        print("请检查输入方程是否为多项式形式，且系数是否兼容。")

xyz_cases = [
    [[2 * x ^ 2 + y ^ 2 - 1, z], [0, t, 0]],
    [[2 * x ^ 2 + y ^ 2 - 1, z], [t, 0, 0]],
    [[z - y ^ 2, x], [0, t, 0]],
    [[z - y ^ 2, x], [0, 0, t]],
]
for curve, line in xyz_cases:
    print("-" * 30)
    print(f"曲线：{curve}")
    print(f"直线：{line}")
    try:
        result_poly = compute_surface_of_revolution_xyz(curve, line)
        print("-" * 30)
        print("计算完成！曲面方程 f(x,y,z) = 0 为：")
        print(f"{result_poly} = 0")
        print("\n(注：若结果包含常数因子，不影响方程几何意义)")

    except Exception as e:
        print(f"发生错误：{e}")
        traceback.print_exc()
        print("请检查输入方程是否为多项式形式，且系数是否兼容。")
