res = zeros(2, 5);
test_times = 10;
for uuu = 1:test_times
    new_template
    res(2,:) = res(2,:) + [res1, res2, res3, res4, res5]; 
    old_template
    res(1,:) = res(1,:) + [res1, res2, res3, res4, res5]; 
    uuu
end
ppp = res/test_times
