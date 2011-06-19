# needs the linear-algebra and communications packages in Octave

h1=[1 1; 1 -1];

h5=kron(kron(kron(kron(h1,h1),h1),h1),h1)

for i = 1:rows(h5)

	for j = 1:rows(h5)
		if (h5(i,j)==1)
			h5(i,j)=0;

		elseif (h5(i,j)==-1)
			h5(i,j)=1;

		endif
	endfor
endfor

m5 = bi2de(h5);


#m5 = [flipud(rot90(x)),m5];

disp(m5)
