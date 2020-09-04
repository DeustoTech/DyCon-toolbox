function h=ObtainAdmissiblePerturbation(y,p,m,Nx,kappa,d)
if d==1
       admP=casadi.Opti();
       H = admP.variable(Nx,1);
       for i=1:Nx
           admP.subject_to(m(i)+H(i)<=kappa);
           admP.subject_to(m(i)+H(i)>=0);
       end
       admP.subject_to(trapz(H)==0);
      admP.minimize(-trapz((y(:).*p(:).*H(:))));
      p_opts = struct('expand',true);
        s_opts = struct('max_iter',1000,'constr_viol_tol',10^(-6),'compl_inf_tol',10^(-6),'acceptable_tol',5*10^(-6));
        admP.solver('ipopt',p_opts,s_opts);
      tic
      sol = admP.solve();   % actual solve
      toc
    
      h=sol.value(H);

end
if d==2
       admP=casadi.Opti();
       H = admP.variable(Nx,Nx);
       for i=1:Nx
           for j=1:Nx
                admP.subject_to(m(i,j)+H(i,j)<=kappa);
                admP.subject_to(m(i,j)+H(i,j)>=0);
           end
       end
       admP.subject_to(sum(sum(H))==0);
       w=y.*p;
    admP.minimize(-sum(sum(w(:).*H(:))));
          p_opts = struct('expand',true);
        s_opts = struct('max_iter',1000,'constr_viol_tol',10^(-6),'compl_inf_tol',10^(-6),'acceptable_tol',5*10^(-6));
        admP.solver('ipopt',p_opts,s_opts);
    tic
    sol = admP.solve();   % actual solve
    toc
    
    h=sol.value(H);
       
end

end
