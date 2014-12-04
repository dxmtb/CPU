import csv
trans_sig = {'PC+1' : 'PC1',
             'Branch-True' : 'B',
             'Branch-Rx-0' : 'Rx_0',
             'Branch-Rx-1' : 'Rx_1',
             'Branch-T-0' : 'T_0'}

with open('./controller.csv') as csvfile:
    fin = csv.reader(csvfile)
    signals = None
    for data in fin:
        if not signals:
            signals = data[1:]
            continue
        ins = data[0]
        sigs = data[1:]
        assert len(sigs) == len(signals)
        print 'when INST_CODE_%s =>' % (ins)
        for i in xrange(len(signals)):
            if len(sigs[i]) and sigs[i] != '*':
                signal = signals[i]
                sig = sigs[i]
                if sig in trans_sig:
                    sig = trans_sig[sig]
                if sig[0] == '(':
                    tmp = sig.split(',')
                    tmp2 = tmp[1].split('-')
                    sig = tmp[0][1:]
                    if sig == 'Shift':
                        sig = 'Shift_4_2'
                    else:
                        sig = sig + '_' + tmp2[0]
                if signal in ['PCSrc']:
                    print 'RetIFRegs.PCSrc    := PCSrc_' + sig + ';'
                elif signal in ['ImmExt', 'RAWrite']:
                    print 'RetIDRegs.%s := %s_%s;' % (signal, signal, sig)
                elif signal in ['Op1Src', 'Op2Src', 'WBDst', 'ALUOp', 'MemData']:
                    print 'RetEXRegs.%s := %s_%s;' % (signal, signal, sig)
                elif signal == 'MemOp' :
                    print 'RetMRegs.MemOp := %s_%s;' % (signal, sig)
                elif signal in ['WBSrc', 'WBEnable']:
                    print 'RetWBRegs.%s := %s_%s;' % (signal, signal, sig)
