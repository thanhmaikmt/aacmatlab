function [sbr,c] = sbr_noise( sbr, bits )
%Table 4.73 – Syntax of sbr_noise()

%Input
bs_num_noise = sbr.data.bs_num_noise;
bs_df_noise = sbr.data.bs_df_noise;
num_noise_bands = sbr.freq_tables.N_Q;

%Tables
t_huff = [
    [ -64,   1 ];    [ -63,   2 ];    [ -65,   3 ];    [ -66,   4 ];
    [ -62,   5 ];    [ -67,   6 ];    [   7,   8 ];    [ -61, -68 ];
    [   9,  30 ];    [  10,  15 ];    [ -60,  11 ];    [ -69,  12 ];
    [  13,  14 ];    [ -59, -53 ];    [ -95, -94 ];    [  16,  23 ];
    [  17,  20 ];    [  18,  19 ];    [ -93, -92 ];    [ -91, -90 ];
    [  21,  22 ];    [ -89, -88 ];    [ -87, -86 ];    [  24,  27 ];
    [  25,  26 ];    [ -85, -84 ];    [ -83, -82 ];    [  28,  29 ];
    [ -81, -80 ];    [ -79, -78 ];    [  31,  46 ];    [  32,  39 ];
    [  33,  36 ];    [  34,  35 ];    [ -77, -76 ];    [ -75, -74 ];
    [  37,  38 ];    [ -73, -72 ];    [ -71, -70 ];    [  40,  43 ];
    [  41,  42 ];    [ -58, -57 ];    [ -56, -55 ];    [  44,  45 ];
    [ -54, -52 ];    [ -51, -50 ];    [  47,  54 ];    [  48,  51 ];
    [  49,  50 ];    [ -49, -48 ];    [ -47, -46 ];    [  52,  53 ];
    [ -45, -44 ];    [ -43, -42 ];    [  55,  58 ];    [  56,  57 ];
    [ -41, -40 ];    [ -39, -38 ];    [  59,  60 ];    [ -37, -36 ];
    [ -35,  61 ];    [ -34, -33 ]];
f_huff = [...
    [ -64,   1 ];    [ -65,   2 ];    [ -63,   3 ];    [ -66,   4 ];...
    [ -62,   5 ];    [ -67,   6 ];    [   7,   8 ];    [ -61, -68 ];...
    [   9,  10 ];    [ -60, -69 ];    [  11,  12 ];    [ -59, -70 ];...
    [  13,  14 ];    [ -58, -71 ];    [  15,  16 ];    [ -57, -72 ];...
    [  17,  19 ];    [ -56,  18 ];    [ -55, -73 ];    [  20,  24 ];...
    [  21,  22 ];    [ -74, -54 ];    [ -53,  23 ];    [ -75, -76 ];...
    [  25,  30 ];    [  26,  27 ];    [ -52, -51 ];    [  28,  29 ];...
    [ -77, -79 ];    [ -50, -49 ];    [  31,  39 ];    [  32,  35 ];...
    [  33,  34 ];    [ -78, -46 ];    [ -82, -88 ];    [  36,  37 ];...
    [ -83, -48 ];    [ -47,  38 ];    [ -86, -85 ];    [  40,  47 ];...
    [  41,  44 ];    [  42,  43 ];    [ -80, -44 ];    [ -43, -42 ];...
    [  45,  46 ];    [ -39, -87 ];    [ -84, -40 ];    [  48,  55 ];...
    [  49,  52 ];    [  50,  51 ];    [ -95, -94 ];    [ -93, -92 ];...
    [  53,  54 ];    [ -91, -90 ];    [ -89, -81 ];    [  56,  59 ];...
    [  57,  58 ];    [ -45, -41 ];    [ -38, -37 ];    [  60,  61 ];...
    [ -36, -35 ];    [ -34, -33 ]];

%Init
c = 0;
bs_data_noise = cell(1,bs_num_noise);

%Huffman decoding
for env=1:bs_num_noise
    if bs_df_noise(env)==0
        bs_data_noise{env}(1) = bits2int( bits(c+1:c+5) );
        c = c + 5;
        for band=2:num_noise_bands
            [bs_data_noise{env}(band),decoded_bits] = sbr_huff_dec(bits(c+1:end), f_huff);
            c = c + decoded_bits;
        end
    else
        for band=1:num_noise_bands
            [bs_data_noise{env}(band),decoded_bits] = sbr_huff_dec(bits(c+1:end), t_huff);
            c = c + decoded_bits;
        end
    end
end

%Output
sbr.data.bs_data_noise = bs_data_noise;