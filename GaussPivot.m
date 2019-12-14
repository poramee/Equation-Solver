
% Copyright 2019 The University of Texas at Austin
%
% For licensing information see
%                http://www.cs.utexas.edu/users/flame/license.html 
%                                                                                 
% Programmed by: Poramee Chansuksett
%                poramee.chansuksett@gmail.com

function [ A_out, b_out ] = GaussPivot( A, b )

  [ ATL, ATR, ...
    ABL, ABR ] = FLA_Part_2x2( A, ...
                               0, 0, 'FLA_TL' );

  [ bT, ...
    bB ] = FLA_Part_2x1( b, ...
                         0, 'FLA_TOP' );

  while ( size( ATL, 1 ) < size( A, 1 ) )

    [ A00,  a01,     A02,  ...
      a10t, alpha11, a12t, ...
      A20,  a21,     A22 ] = FLA_Repart_2x2_to_3x3( ATL, ATR, ...
                                                    ABL, ABR, ...
                                                    1, 1, 'FLA_BR' );

    [ b0, ...
      beta1, ...
      b2 ] = FLA_Repart_2x1_to_3x1( bT, ...
                                    bB, ...
                                    1, 'FLA_BOTTOM' );

    %------------------------------------------------------------%
    
    piv = Pivot([alpha11;a21]);
    temp = piv*[alpha11 a12t;a21 A22];
    temp2 = piv*[beta1;b2];
    
    beta1 = temp2(1,1);
    b2 = temp2(2:end,:);
    
    
    alpha11 = temp(1,1);
    a12t = temp(1,2:end);
    a21 = temp(2:end,1);
    A22 = temp(2:end,2:end);
    
    a21 = a21 / alpha11;
%     a21 = laff_zerov(a21);
    A22 = A22 - a21*a12t;
    
    b2 = b2 - a21*beta1;
    
    
    %------------------------------------------------------------%

    [ ATL, ATR, ...
      ABL, ABR ] = FLA_Cont_with_3x3_to_2x2( A00,  a01,     A02,  ...
                                             a10t, alpha11, a12t, ...
                                             A20,  a21,     A22, ...
                                             'FLA_TL' );

    [ bT, ...
      bB ] = FLA_Cont_with_3x1_to_2x1( b0, ...
                                       beta1, ...
                                       b2, ...
                                       'FLA_TOP' );

  end

  A_out = [ ATL, ATR
            ABL, ABR ];

  b_out = [ bT
            bB ];

return
