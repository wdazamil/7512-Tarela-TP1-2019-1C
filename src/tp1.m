global TC = 45; # Tipo de cambio ($/usd)
global Pot = 30; # Potencia instalada (kWp)
global CU = 1200; # Costo unitario de la potencia instalada (usd/kWp)
global CUARS = CU*TC;
global NP = 90562;
global Alpha = 0.3; # Impuesto a las ganancias
global CElec = 3.2; # Costo de la electricidad consumida ($/kW h)
global CPot = 610; # Costo de la potencia contratada y consumida ($/kW mes)
global N = 20; # Cantidad de a�os
global Costosn = 10000; # Costos ($/a�o)

# Inversi�n inicial
function ret = I0(pot, cu)
  ret = pot * cu;
endfunction

# Factor de uso
function ret = FU(np)
  ret = 0.18 * np * 100000;
endfunction

# Free Cash Flow
function ret = FCF(ahorros, costos, a)
  ret = (ahorros - costos)*(1-a);
endfunction

# Ahorro de energ�a
# pot: (kW)
# celec: ($/kW h)
function ret = AhorroEnergia(pot, fu, celec)
  ret = pot * 8760 * fu * celec;
endfunction

# Ahorro de potencia
# pot: (kW)
# cpot: ($/kw mes)
function ret = AhorroPotencia(pot, cpot)
  ret = pot * 0.3 * cpot * 12;
endfunction

# Ahorros
function ret = Ahorros(ae, ap)
  ret = ae * ap;
endfunction

# Costos
# c: ($/a�o)
function ret = Costos(c)
  ret = c;
endfunction

function ret = M(M0, i, n)
  ret = M0*(1 + i)**n;
endfunction

function ret = GetCostos(n, c)
  ret = zeros(n, 1);
  for i = 1:n
    ret(i) = Costos(c);
  endfor
endfunction

function ret = GetAhorroEnergia(n, pot, fu, celec)
  ret = zeros(n, 1);
  for i = 1:n
    ret(i) = AhorroEnergia(pot, fu, celec);
  endfor
endfunction

function ret = GetAhorroPotencia(n, pot, cpot)
  ret = zeros(n, 1);
  for i = 1:n
    ret(i) = AhorroPotencia(pot, cpot);
  endfor
endfunction

function ret = GetAhorros(n, ae, ap)
  ret = zeros(n, 1);
  for i = 1:n
    ret(i) = Ahorros(ae(i), ap(i));
  endfor
endfunction

function ret = GetFCF(n, ahorros, costos, a)
  ret = zeros(n, 1);
  for i = 1:n
    ret(i) = FCF(ahorros(i), costos(i), a);
  endfor
endfunction

function ret = VAN(i0, n, fcf, i)
  ret = -i0;
  for j = 1:n
    ret+=(fcf(j)/((1+i)**j));
  endfor
endfunction

function ret = VANF(i)
  global N;
  global Pot;
  global CUARS;
  global CElec;
  global CPot;
  global Costosn;
  global Alpha;
  global NP;
  n = N;
  i0 = I0(Pot, CUARS);
  fcf = GetFCF(n, GetAhorros(n, GetAhorroEnergia(n, Pot, FU(NP), CElec), GetAhorroPotencia(n, Pot, CPot)), GetCostos(n, Costosn), Alpha);
  ret = VAN(i0, n, fcf, i);
endfunction

# M�todo de bisecci�n
# f: function handle
# a: inicio intervalo
# b: fin intervalo
# e: precisi�n (%)
function ret = biseccion(f,a,b,e)
  ai = a;
  bi = b;
  while (abs(((bi - ai)/2)/((ai + bi) / 2)) > (e/100))
  #while  (((bi - ai)/2) > e)
    m = (ai + bi)/2;
    if (f(m) == 0)
      ret = m;
      break;
    endif
    if ( (f(ai)*f(m)) > 0 )
      ai = m;
    else
      bi = m;
    endif
  endwhile
  ret = (ai + bi) / 2;
endfunction

function ret = puntofijo(f, x0, e)
  xi = x0;
  while (abs(((xi - f(xi)) - xi)/(xi - f(xi))) > e)
    xi = xi - f(xi);
  endwhile
  ret = xi;
endfunction

#biseccion(@VANF, 0.05, 0.06, 5)
#biseccion(@VANF, 0.0563, 0.0564, 5)
#biseccion(@VANF, 0.05635, 0.05646, 5)
#biseccion(@VANF, 0.05, 0.06, 1e-3)
#puntofijo(@VANF, 0.0545, 0.001) 









function hello
  printf ("hola mundo");
endfunction

function main(f)
  f()
  f()
endfunction