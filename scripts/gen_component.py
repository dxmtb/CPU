import sys
for fname in sys.argv[1:]:
    if fname != 'CPU.vhd':
        output = ''
        status = 0
        with open(fname) as fin:
            for line in fin:
                if 'entity' in line.lower():
                    status += 1
                    line = line.replace('entity', 'component')
                    name = line.split()[1]
                    output += line
                    continue
                if status == 1 and 'end' in line.lower():
                    line = line.replace(name, 'component')
                    status += 1
                if status != 0 and status <= 2:
                    output += line
                if status == 2:
                    break
        if len(output.strip()):
            print '--' + fname
            print output

