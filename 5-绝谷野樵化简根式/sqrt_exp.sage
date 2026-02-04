K.<sqrt2, sqrt3> = NumberField([x ^ 2 - 2, x ^ 2 - 3])
sqrt6 = sqrt2 * sqrt3
expr = 11 * sqrt2 + 9 * sqrt3
result1 = expr ^ 6
result2 = expr ^ 5
v1 = result1.vector()
v2 = result2.vector()
print(result1, type(result1), v1)
print(result2, type(result2), v2)
vv1 = v1[1].vector()
vv2 = v2[0].vector()
print(vv1, type(vv1))
print(vv2, type(vv2))

expr2 = 7 + 3 * sqrt2 + 2 * sqrt3
result21 = expr2 ^ 5
print(result21)

expr3 = -1 + sqrt2 + sqrt3
result31 = expr3 ^ 5
print(result31)

print('5-绝谷野樵化简根式/solve_sqrt236.sage 的验算：')
val1 = (7 / 6 * sqrt6 + 4 / 3 * sqrt3 + 3 / 2 * sqrt2 + 8) ^ 3 - (1028 + 1159 / 2 * sqrt2 + 4336 / 9 * sqrt3 + 6551 / 18 * sqrt6)
val2 = (1 / 6 * sqrt6 + 1 / 3 * sqrt3 + 1 / 2 * sqrt2 + 1) ^ 2 - (2 + 4 / 3 * sqrt2 + sqrt3 + 2 / 3 * sqrt6)
val3 = (sqrt3 + 7 / 6 * sqrt6) ^ 2 - (67 / 6 + 7 * sqrt2)
val4 = (1 + 4 / 3 * sqrt3 + 3 / 4 * sqrt6) ^ 2 - (233 / 24 + 6 * sqrt2 + 8 / 3 * sqrt3 + 3 / 2 * sqrt6)
print(val1, val2, val3, val4)

'''
186298002*sqrt3*sqrt2 + 456335045 <class 'sage.rings.number_field.number_field_element.NumberFieldElement_relative'> (456335045, 186298002*sqrt3)
10360559*sqrt2 + 8459361*sqrt3 <class 'sage.rings.number_field.number_field_element.NumberFieldElement_relative'> (8459361*sqrt3, 10360559)
(0, 186298002) <class 'sage.modules.vector_rational_dense.Vector_rational_dense'>
(0, 8459361) <class 'sage.modules.vector_rational_dense.Vector_rational_dense'>
(66360*sqrt3 + 125007)*sqrt2 + 96538*sqrt3 + 181447
(-120*sqrt3 + 224)*sqrt2 + 184*sqrt3 - 296
'''
