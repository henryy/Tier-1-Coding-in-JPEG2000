function reg_dec = mq_renormalize_once(reg_dec)


if reg_dec.t == 0
    reg_dec = mq_fill_lsbs(reg_dec);
end
reg_dec.A = 2*reg_dec.A;
reg_dec.C = 2*reg_dec.C;
reg_dec.t = reg_dec.t-1;