f = open('pedigree.ged', 'r')
res = open('CP.pl', 'w')
identificator = dict()
while True:
	line = f.readline()
	words = line.split()
	if ( words[0] == '0' and words[1] != 'HEAD' and words[1] != 'TRLR' ):
		if ( words[2] == 'INDI' ):
			index = words[1]
			f.readline()
			f.readline()
			line = f.readline()
			words = line.split()
			givn = words[2]
			line = f.readline()
			words = line.split()
			sern = words[2]
			identificator[index] = str(givn + " " + sern)
			line = f.readline()
			words = line.split()
			if ( words[2] == 'F' ):
				res.write("sex('"+identificator[index]+"', 'female').\n")
			elif ( words[2] == 'M' ):
				res.write("sex('"+identificator[index]+"', 'male').\n")
		elif ( words[2] == 'FAM' ):
			f.readline()
			line = f.readline()
			words = line.split()
			par = identificator[words[2]]
			line = f.readline()
			words = line.split()
			if ( words[1] == 'WIFE' ):
				wife = identificator[words[2]]
				line = f.readline()
				words = line.split()
				while ( words[1] == 'CHIL' ):
					res.write("parent('"+par+"', '"+identificator[words[2]]+"').\n")
					res.write("parent('"+wife+"', '"+identificator[words[2]]+"').\n")
					line = f.readline()
					words = line.split()
			else:
				while ( words[1] == 'CHIL' ):
					res.write("parent('"+par+"', '"+identificator[words[2]]+"').\n")
					line = f.readline()
					words = line.split()
	elif ( words[0] == '0' and words[1] == 'TRLR' ):
		break
f.close()
res.close()