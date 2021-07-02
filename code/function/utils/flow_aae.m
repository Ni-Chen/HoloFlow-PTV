function [aae, sae] = flow_aae(f1, f2, mask)
    %FLOW_AAE   Average angular error in optical flow computation
    %   AAE = FLOW_AAE(F1, F2[, MASK]) computes the average angular error in
    %   degrees between the flow fields F1 and F2.  The optional argument
    %   MASK can specify which of the pixels should be taken into account.
    %
    %   [AAE, SAE] = FLOW_AAE(F1, F2[, MASK]) also returns the standard
    %   deviation of the angular error.
    %
    %   Author:  Stefan Roth, Department of Computer Science, TU Darmstadt
    %   Contact: sroth@cs.tu-darmstadt.de
    %   Date:2007−03−2714:09:11−0400(Tue,27Mar2007)
    %   Revision:252

    aae = acos((sum(f1 .* f2, 4) + 1) ./ ...
        sqrt((sum(f1.^2, 4) + 1) .* (sum(f2.^2, 4) + 1)));

    if (nargin > 2)
        aae = aae(mask);
    end

    sae = std(real(aae(:))) * (180 / pi);
    aae = mean(real(aae(:))) * (180 / pi);
end
