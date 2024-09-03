module __f32add__main(
  input wire [31:0] x,
  input wire [31:0] y,
  output wire [31:0] out
);
  wire [7:0] y_bexp__1;
  wire [7:0] x_bexp__1;
  wire [8:0] sum;
  wire [22:0] tuple_index_1621;
  wire [22:0] tuple_index_1622;
  wire [7:0] y_bexp__2;
  wire [22:0] y_fraction__1;
  wire [7:0] incremented_sum__1;
  wire [27:0] wide_y;
  wire [7:0] x_bexpbs_difference__1;
  wire [7:0] x_bexp__2;
  wire [27:0] wide_y__1;
  wire [7:0] sub_1640;
  wire [22:0] x_fraction__2;
  wire [27:0] dropped;
  wire [27:0] wide_x;
  wire tuple_index_1650;
  wire tuple_index_1651;
  wire [27:0] wide_x__1;
  wire x_sign__2;
  wire y_sign__2;
  wire [27:0] neg_1657;
  wire [27:0] sticky;
  wire [27:0] xddend_y__2;
  wire [24:0] sel_1664;
  wire [25:0] add_1669;
  wire [27:0] concat_1672;
  wire [27:0] xbs_fraction__2;
  wire [27:0] reverse_1676;
  wire [28:0] one_hot_1677;
  wire [4:0] encode_1678;
  wire cancel__2;
  wire carry_bit;
  wire [27:0] leading_zeroes;
  wire [26:0] carry_fraction;
  wire [27:0] add_1695;
  wire [2:0] concat_1696;
  wire [26:0] carry_fraction__1;
  wire [26:0] cancel_fraction;
  wire [26:0] shifted_fraction;
  wire [2:0] normal_chunk;
  wire [2:0] fraction_shift__3;
  wire [1:0] half_way_chunk;
  wire [24:0] add_1711;
  wire do_round_up;
  wire [27:0] rounded_fraction;
  wire rounding_carry;
  wire [8:0] add_1722;
  wire [9:0] add_1730;
  wire [9:0] wide_exponent;
  wire [9:0] wide_exponent__1;
  wire [7:0] MAX_EXPONENT;
  wire [7:0] MAX_EXPONENT__1;
  wire [8:0] wide_exponent__2;
  wire [7:0] MAX_EXPONENT__3;
  wire [7:0] MAX_EXPONENT__4;
  wire eq_1751;
  wire eq_1752;
  wire eq_1753;
  wire eq_1754;
  wire ne_1757;
  wire ne_1759;
  wire fraction_is_zero;
  wire [2:0] fraction_shift__2;
  wire [2:0] fraction_shift__4;
  wire is_operand_inf;
  wire and_reduce_1776;
  wire has_pos_inf;
  wire has_neg_inf;
  wire [2:0] fraction_shift__1;
  wire [2:0] concat_1786;
  wire [27:0] shrl_1789;
  wire is_result_nan;
  wire result_sign;
  wire [22:0] result_fraction;
  wire result_sign__1;
  wire [7:0] MAX_EXPONENT__2;
  wire [22:0] result_fraction__3;
  wire [22:0] FRACTION_HIGH_BIT;
  wire result_sign__2;
  wire [7:0] result_exponent__2;
  wire [22:0] result_fraction__4;
  assign y_bexp__1 = y[30:23];
  assign x_bexp__1 = x[30:23];
  assign sum = {1'h0, x_bexp__1} + {1'h0, ~y_bexp__1};
  assign tuple_index_1621 = x[22:0];
  assign tuple_index_1622 = y[22:0];
  assign y_bexp__2 = sum[8] ? y_bexp__1 : x_bexp__1;
  assign y_fraction__1 = sum[8] ? tuple_index_1622 : tuple_index_1621;
  assign incremented_sum__1 = sum[7:0] + 8'h01;
  assign wide_y = {2'h1, y_fraction__1, 3'h0};
  assign x_bexpbs_difference__1 = sum[8] ? incremented_sum__1 : ~sum[7:0];
  assign x_bexp__2 = sum[8] ? x_bexp__1 : y_bexp__1;
  assign wide_y__1 = wide_y & {28{y_bexp__2 != 8'h00}};
  assign sub_1640 = 8'h1c - x_bexpbs_difference__1;
  assign x_fraction__2 = sum[8] ? tuple_index_1621 : tuple_index_1622;
  assign dropped = sub_1640 >= 8'h1c ? 28'h000_0000 : wide_y__1 << sub_1640;
  assign wide_x = {2'h1, x_fraction__2, 3'h0};
  assign tuple_index_1650 = y[31:31];
  assign tuple_index_1651 = x[31:31];
  assign wide_x__1 = wide_x & {28{x_bexp__2 != 8'h00}};
  assign x_sign__2 = sum[8] ? tuple_index_1651 : tuple_index_1650;
  assign y_sign__2 = sum[8] ? tuple_index_1650 : tuple_index_1651;
  assign neg_1657 = -wide_x__1;
  assign sticky = {27'h000_0000, dropped[27:3] != 25'h000_0000};
  assign xddend_y__2 = (x_bexpbs_difference__1 >= 8'h1c ? 28'h000_0000 : wide_y__1 >> x_bexpbs_difference__1) | sticky;
  assign sel_1664 = x_sign__2 ^ y_sign__2 ? neg_1657[27:3] : wide_x__1[27:3];
  assign add_1669 = {{1{sel_1664[24]}}, sel_1664} + {1'h0, xddend_y__2[27:3]};
  assign concat_1672 = {add_1669[24:0], xddend_y__2[2:0]};
  assign xbs_fraction__2 = add_1669[25] ? -concat_1672 : concat_1672;
  assign reverse_1676 = {xbs_fraction__2[0], xbs_fraction__2[1], xbs_fraction__2[2], xbs_fraction__2[3], xbs_fraction__2[4], xbs_fraction__2[5], xbs_fraction__2[6], xbs_fraction__2[7], xbs_fraction__2[8], xbs_fraction__2[9], xbs_fraction__2[10], xbs_fraction__2[11], xbs_fraction__2[12], xbs_fraction__2[13], xbs_fraction__2[14], xbs_fraction__2[15], xbs_fraction__2[16], xbs_fraction__2[17], xbs_fraction__2[18], xbs_fraction__2[19], xbs_fraction__2[20], xbs_fraction__2[21], xbs_fraction__2[22], xbs_fraction__2[23], xbs_fraction__2[24], xbs_fraction__2[25], xbs_fraction__2[26], xbs_fraction__2[27]};
  assign one_hot_1677 = {reverse_1676[27:0] == 28'h000_0000, reverse_1676[27] && reverse_1676[26:0] == 27'h000_0000, reverse_1676[26] && reverse_1676[25:0] == 26'h000_0000, reverse_1676[25] && reverse_1676[24:0] == 25'h000_0000, reverse_1676[24] && reverse_1676[23:0] == 24'h00_0000, reverse_1676[23] && reverse_1676[22:0] == 23'h00_0000, reverse_1676[22] && reverse_1676[21:0] == 22'h00_0000, reverse_1676[21] && reverse_1676[20:0] == 21'h00_0000, reverse_1676[20] && reverse_1676[19:0] == 20'h0_0000, reverse_1676[19] && reverse_1676[18:0] == 19'h0_0000, reverse_1676[18] && reverse_1676[17:0] == 18'h0_0000, reverse_1676[17] && reverse_1676[16:0] == 17'h0_0000, reverse_1676[16] && reverse_1676[15:0] == 16'h0000, reverse_1676[15] && reverse_1676[14:0] == 15'h0000, reverse_1676[14] && reverse_1676[13:0] == 14'h0000, reverse_1676[13] && reverse_1676[12:0] == 13'h0000, reverse_1676[12] && reverse_1676[11:0] == 12'h000, reverse_1676[11] && reverse_1676[10:0] == 11'h000, reverse_1676[10] && reverse_1676[9:0] == 10'h000, reverse_1676[9] && reverse_1676[8:0] == 9'h000, reverse_1676[8] && reverse_1676[7:0] == 8'h00, reverse_1676[7] && reverse_1676[6:0] == 7'h00, reverse_1676[6] && reverse_1676[5:0] == 6'h00, reverse_1676[5] && reverse_1676[4:0] == 5'h00, reverse_1676[4] && reverse_1676[3:0] == 4'h0, reverse_1676[3] && reverse_1676[2:0] == 3'h0, reverse_1676[2] && reverse_1676[1:0] == 2'h0, reverse_1676[1] && !reverse_1676[0], reverse_1676[0]};
  assign encode_1678 = {one_hot_1677[16] | one_hot_1677[17] | one_hot_1677[18] | one_hot_1677[19] | one_hot_1677[20] | one_hot_1677[21] | one_hot_1677[22] | one_hot_1677[23] | one_hot_1677[24] | one_hot_1677[25] | one_hot_1677[26] | one_hot_1677[27] | one_hot_1677[28], one_hot_1677[8] | one_hot_1677[9] | one_hot_1677[10] | one_hot_1677[11] | one_hot_1677[12] | one_hot_1677[13] | one_hot_1677[14] | one_hot_1677[15] | one_hot_1677[24] | one_hot_1677[25] | one_hot_1677[26] | one_hot_1677[27] | one_hot_1677[28], one_hot_1677[4] | one_hot_1677[5] | one_hot_1677[6] | one_hot_1677[7] | one_hot_1677[12] | one_hot_1677[13] | one_hot_1677[14] | one_hot_1677[15] | one_hot_1677[20] | one_hot_1677[21] | one_hot_1677[22] | one_hot_1677[23] | one_hot_1677[28], one_hot_1677[2] | one_hot_1677[3] | one_hot_1677[6] | one_hot_1677[7] | one_hot_1677[10] | one_hot_1677[11] | one_hot_1677[14] | one_hot_1677[15] | one_hot_1677[18] | one_hot_1677[19] | one_hot_1677[22] | one_hot_1677[23] | one_hot_1677[26] | one_hot_1677[27], one_hot_1677[1] | one_hot_1677[3] | one_hot_1677[5] | one_hot_1677[7] | one_hot_1677[9] | one_hot_1677[11] | one_hot_1677[13] | one_hot_1677[15] | one_hot_1677[17] | one_hot_1677[19] | one_hot_1677[21] | one_hot_1677[23] | one_hot_1677[25] | one_hot_1677[27]};
  assign cancel__2 = |encode_1678[4:1];
  assign carry_bit = xbs_fraction__2[27];
  assign leading_zeroes = {23'h00_0000, encode_1678};
  assign carry_fraction = xbs_fraction__2[27:1];
  assign add_1695 = leading_zeroes + 28'hfff_ffff;
  assign concat_1696 = {~(carry_bit | cancel__2), ~(carry_bit | ~cancel__2), ~(~carry_bit | cancel__2)};
  assign carry_fraction__1 = carry_fraction | {26'h000_0000, xbs_fraction__2[0]};
  assign cancel_fraction = add_1695 >= 28'h000_001b ? 27'h000_0000 : xbs_fraction__2[26:0] << add_1695;
  assign shifted_fraction = carry_fraction__1 & {27{concat_1696[0]}} | cancel_fraction & {27{concat_1696[1]}} | xbs_fraction__2[26:0] & {27{concat_1696[2]}};
  assign normal_chunk = shifted_fraction[2:0];
  assign fraction_shift__3 = 3'h4;
  assign half_way_chunk = shifted_fraction[3:2];
  assign add_1711 = {1'h0, shifted_fraction[26:3]} + 25'h000_0001;
  assign do_round_up = normal_chunk > fraction_shift__3 | half_way_chunk == 2'h3;
  assign rounded_fraction = do_round_up ? {add_1711, normal_chunk} : {1'h0, shifted_fraction};
  assign rounding_carry = rounded_fraction[27];
  assign add_1722 = {1'h0, x_bexp__2} + {8'h00, rounding_carry};
  assign add_1730 = {1'h0, add_1722} + 10'h001;
  assign wide_exponent = add_1730 - {5'h00, encode_1678};
  assign wide_exponent__1 = wide_exponent & {10{add_1669 != 26'h000_0000 | xddend_y__2[2:0] != 3'h0}};
  assign MAX_EXPONENT = 8'hff;
  assign MAX_EXPONENT__1 = 8'hff;
  assign wide_exponent__2 = wide_exponent__1[8:0] & {9{~wide_exponent__1[9]}};
  assign MAX_EXPONENT__3 = 8'hff;
  assign MAX_EXPONENT__4 = 8'hff;
  assign eq_1751 = x_bexp__2 == MAX_EXPONENT;
  assign eq_1752 = x_fraction__2 == 23'h00_0000;
  assign eq_1753 = y_bexp__2 == MAX_EXPONENT__1;
  assign eq_1754 = y_fraction__1 == 23'h00_0000;
  assign ne_1757 = x_fraction__2 != 23'h00_0000;
  assign ne_1759 = y_fraction__1 != 23'h00_0000;
  assign fraction_is_zero = add_1669 == 26'h000_0000 & xddend_y__2[2:0] == 3'h0;
  assign fraction_shift__2 = 3'h3;
  assign fraction_shift__4 = 3'h4;
  assign is_operand_inf = eq_1751 & eq_1752 | eq_1753 & eq_1754;
  assign and_reduce_1776 = &wide_exponent__2[7:0];
  assign has_pos_inf = ~(x_bexp__2 != MAX_EXPONENT__3 | ne_1757 | x_sign__2) | ~(y_bexp__2 != MAX_EXPONENT__4 | ne_1759 | y_sign__2);
  assign has_neg_inf = eq_1751 & eq_1752 & x_sign__2 | eq_1753 & eq_1754 & y_sign__2;
  assign fraction_shift__1 = rounding_carry ? fraction_shift__4 : fraction_shift__2;
  assign concat_1786 = {~(add_1669[25] | fraction_is_zero), add_1669[25], fraction_is_zero};
  assign shrl_1789 = rounded_fraction >> fraction_shift__1;
  assign is_result_nan = eq_1751 & ne_1757 | eq_1753 & ne_1759 | has_pos_inf & has_neg_inf;
  assign result_sign = x_sign__2 & y_sign__2 & concat_1786[0] | ~y_sign__2 & concat_1786[1] | y_sign__2 & concat_1786[2];
  assign result_fraction = shrl_1789[22:0];
  assign result_sign__1 = is_operand_inf ? ~has_pos_inf : result_sign;
  assign MAX_EXPONENT__2 = 8'hff;
  assign result_fraction__3 = result_fraction & {23{~(is_operand_inf | wide_exponent__2[8] | and_reduce_1776 | ~((|wide_exponent__2[8:1]) | wide_exponent__2[0]))}};
  assign FRACTION_HIGH_BIT = 23'h40_0000;
  assign result_sign__2 = ~is_result_nan & result_sign__1;
  assign result_exponent__2 = is_result_nan | is_operand_inf | wide_exponent__2[8] | and_reduce_1776 ? MAX_EXPONENT__2 : wide_exponent__2[7:0];
  assign result_fraction__4 = is_result_nan ? FRACTION_HIGH_BIT : result_fraction__3;
  assign out = {result_sign__2, result_exponent__2, result_fraction__4};
endmodule