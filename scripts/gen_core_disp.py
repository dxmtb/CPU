regs = ['PC', 'SP', 'IH', 'reg0', 'reg1', 'reg2', 'reg3', 'reg4', 'reg5', 'reg6', 'reg7', 'T']

assert len(regs) == 12
for i, reg in enumerate(regs):
    ifs = 'if'
    if i != 0:
        ifs = 'elsif'
    print '%s y_pos >= %d and y_pos < %d then' % (ifs, i*40, (i+1)*40)
    for j in reversed(xrange(16)):
        ifs2 = 'if'
        if j != 15:
            ifs2 = 'elsif'
        print '  %s x_pos >= %d and x_pos < %d then' % (ifs2, (15-j)*40, (15-j+1)*40)
        print '    rgb <= %s(%d);' % (reg, j)
    print '  end if;'
print 'end if;'

