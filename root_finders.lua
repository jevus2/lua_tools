-- root_finders.lua
--
-- Adaptation from secant.lua in the dgd repo
-- to allow for functions with more than one
-- variable
--
-- J.Kunze 2021-12-17
--
-- PAJ 2018-04-27, 2019-07-15
-- Adapted from the Python version in zero_solvers.py
--
--- @module root_finders
local root_finders = {}

--[=[
The iterative secant method for zero-finding in one-dimension.

   f: user-defined function f(x, args)
   args: table of all constants passed to the function
   x0: first guess
   x1: second guess, presumably close to x0
   tol: stopping tolerance for f(x)=0
   limits: array of the min and max values allowed for x
   max_iterations: to stop the iterations running forever, just in case...

   returns: x, err
   such that f(x)=0 and err is an error message (nil on success)
--]=]
function root_finders.secant(f, args, x0, x1, tol, limits, max_iterations)
   tol = tol or 1.0e-11
   limits = limits or {}
   max_iterations = max_iterations or 1000
   -- We're going to arrange x0 as the oldest (furtherest) point
   -- and x1 as the closer-to-the-solution point.
   -- x2, when we compute it, will be the newest sample point.
   local f0 = f(x0, args); local f1 = f(x1, args)
   if math.abs(f0) < math.abs(f1) then
      x0, f0, x1, f1 = x1, f1, x0, f0
   end
   if math.abs(f1) < tol then
      -- We have success, even before we start.
      return x1, nil
   end
   for i=1,max_iterations do
      local df = f0 - f1
      if df == 0.0 then
         return x1, "FAIL: zero slope"
      end
      x2 = x1 - f1 * (x0 - x1) / (f0 - f1)
      if #limits == 2 then
         x2 = math.min(limits[2], math.max(limits[1], x2))
      end
      f2 = f(x2, args)
      if TEST_MODULE then
         print(string.format('  %d \t  %f \t %f \t %f \t %e', i+1,x0,x1,x2,f2))
      end
      x0, f0, x1, f1 = x1, f1, x2, f2
      if math.abs(f2) < tol then
         -- We have finished successfully.
         return x2, nil
      end
   end
   return x2, 'FAIL, did not converge'
end

--[=[
The iterative brent method for zero-finding in one-dimension.

   f: user-defined function f(x, args)
   args: table of all constants passed to the function
   a: lower limit
   b: upper limit
   tol: stopping tolerance for f(x)=0
   max_iterations: to stop the iterations running forever, just in case...

   returns: x, err
   such that f(x)=0 and err is an error message (nil on success)

   a and b need to bracket the root, otherwise an error is returned
--]=]
function root_finders.brent(f, a, b, args, tol, max_iterations)
    args = args or {}
    tol = tol or 1.0e-11
    max_iterations = max_iterations or 1000
    fa = f(a, args)
    fb = f(b, args)
    if fa * fb > 0 then
        error('limits a and b in brent root finder don\'t bracket the root')
    elseif math.abs(fa) <= tol then
        -- a is a root
        print('a is the root', a)
        return a, nil
    elseif math.abs(fb) <= tol then
        -- b is a root
        print('b is the root', b)
        return b, nil
    end

    if math.abs(fa) < math.abs(fb) then
        local temp = a
        a = b
        b = temp
        fa = f(a, args)
        fb = f(b, args)
    end

    c = a
    fc = fa
    mflag = true
    iteration = 1
    
    while fb ~= 0 and math.abs(b - a) > tol do
        if fa ~= fc and fb ~= fc then
            -- inverse quadratic interpolation
            local term1 = a * fb * fc / ((fa - fb) * (fa - fc))
            local term2 = b * fa * fc / ((fb - fa) * (fb - fc))
            local term3 = c * fa * fb / ((fc - fa) * (fc - fb))
            s = term1 + term2 + term3
        else
            -- secant method
            s = b - fb * (b - a) / (fb - fa)
        end

        condition_1 = (s - (3 * a + b) / 4) * (s - b) >= 0 
        condition_2 = mflag and math.abs(s - b) >= math.abs(b - c) / 2
        condition_3 = not mflag and math.abs(s - b) >= math.abs(c - d) / 2
        condition_4 = mflag and math.abs(b - c) < tol
        condition_5 = not mflag and math.abs(c - d) < tol
        if condition_1 or condition_2 or condition_3 or condition_4 or condition_5 then
            -- bisection method
            s = (a + b) / 2 
            mflag = true
        else
            mflag = false
        end

        fs = f(s, args)
        d = c 
        c = b
        fc = fb

        if fa * fs < 0 then
            b = s
            fb = fs
        else
            a = s
            fa = fs
        end
        if math.abs(fa) < math.abs(fb) then
            local temp, temp_fa = a, fa
            a = b
            b = temp
            fa = fb
            fb = temp_fa
        end
        iteration = iteration + 1
        if iteration > max_iterations then return b, 'max iterations exceeded' end
    end
    return b, nil
end

return root_finders
