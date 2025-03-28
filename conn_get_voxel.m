function x=conn_get_voxel(V,nv)

if nargin<2, error('insufficient arguments'); end
if any(conn_server('util_isremotefile',V.fname)), V.fname=conn_server('util_localfile',V.fname); x=conn_server('run',mfilename,V,nv); return; end
V.fname=conn_server('util_localfile',V.fname);

if isfield(V,'softlink')&&~isempty(V.softlink), 
    str1=regexp(V.fname,'Subject\d+','match'); if ~isempty(str1), V.softlink=regexprep(V.softlink,'Subject\d+',str1{end}); end
    [file_path,file_name,file_ext]=fileparts(V.fname);
    matcfilename=fullfile(file_path,V.softlink); 
else
    matcfilename=[V.fname,'c'];
end
if numel(nv)>=3 % ijk to nv
    nv=V.voxelsinv(max(1,min(V.matdim.dim(1),round(nv(1)))),max(1,min(V.matdim.dim(2),round(nv(2)))),max(1,min(V.matdim.dim(3),round(nv(3)))));
end
if nv==0, x=[]; return; end
handle=fopen(matcfilename,'r+b');
ok=fseek(handle,4*((nv-1)*V.size.Nt),-1);
if ok<0, 
    error('error while reading from file'); 
end 
x=fread(handle,V.size.Nt,'float');
fclose(handle);
