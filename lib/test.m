while 1 > 0
    a = [0, 0];
    b = [1, 0];
    c = rand(1, 2);
    c = c / norm(c)
    calculate_angular_error(a, b, a, c)
    m = [b; c; [0, 1]]';
    plotv(m,'-');
    pause
end