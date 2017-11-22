import numpy as np 
import xlrd
import xlwt
from scipy import misc
def main():
	excel=xlrd.open_workbook('A题附件.xls')
	for nameindex in excel.sheet_names():
		table=excel.sheet_by_name(nameindex)
		nrows = table.nrows
		ncols = table.ncols
		adjmatrix=np.zeros([nrows,ncols,3])
		for i in range(nrows):
			for j in range(ncols):
				#print(table.cell(i,j).value)
				if table.cell(i,j).value==0:
					adjmatrix[i,j,:]=[0,0,0]
				else:
					adjmatrix[i,j,:]=[255,255,255]
		misc.imsave(nameindex+'.jpg',np.uint8(adjmatrix))
main()