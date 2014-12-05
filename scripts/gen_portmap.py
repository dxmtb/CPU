import sys

signals = []

for fname in sys.argv[1:]:
    if fname != 'CPU.vhd':
        output = ''
        status = 0
        with open(fname) as fin:
            for line in fin:
                if len(line.strip()) == 0:
                    continue
                if line.strip()[0] == ')':
                    continue
                if 'entity' in line.lower():
                    status += 1
                    line = line.replace('entity', 'component')
                    if status == 1:
                        entity_name = name = line.split()[1]
                        output += 'One_%s : %s port map (\n' % (name, name)
                    continue
                if status == 1 and 'end' in line.lower():
                    status += 1
                    break
                if status == 1:
                    name = line.split()[0]
                    if name.lower() == 'port':
                        continue
                    if 'out' in line.lower():
                        new_name = entity_name + '_' + name
                    else:
                        new_name = ''
                    types = ' '.join(line.split()[3:]).strip(';')
                    if len(new_name):
                        signals.append('signal %s : %s;' % (new_name, types))
                    output += '%s => %s,\n' % (name, new_name)
        if len(output.strip()):
            print '--' + fname
            print output.strip().strip(',') + '\n' + ');'

print '\n'.join(signals)
