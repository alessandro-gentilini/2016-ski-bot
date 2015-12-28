library(XML)

extract_info <- function(file_name)
{
  doc <- htmlParse(file_name)
  local_name = c()
  local_email = c()
  for ( i in seq(1,10) ){
    name_xpath = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
    name_xpath = paste(name_xpath,']/section[2]/a',sep='')
    local_name=c(local_name,xpathSApply(doc,name_xpath,xmlValue))
    
    email_xpath = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
    email_xpath = paste(email_xpath,']/section[3]/p/a[2]',sep='')
    x<-xpathSApply(doc,email_xpath,xmlValue)
    if(is.null(x) || length(x)==0 || x==''){
      x='no_mail'
      print('************************NO MAIL***************')
    }
    local_email = c(local_email,x)
  }
  if(length(local_name)==length(local_email)){
    df <- data.frame(name=local_name,email=local_email)
    file_name = paste('list_',j,sep='')
    file_name = paste(file_name,'.txt',sep='')
    write.table(df,file=file_name, row.names = FALSE, sep=",", quote=FALSE)  
  }

  return(c(local_name,local_email))
}

name=c()
email=c()

for ( j in seq(0,1534,10) ) {
  cl_options <- paste('--post-data "search=1&feratelSort=3&feratelOffset=',j,sep='')
  cl_options <- paste(cl_options,'"',sep='')
  file_name = paste('f_',j,sep='')
  file_name = paste(file_name,'.html',sep='')
  download.file('http://www.oetztal.com/accommodation-list-winter#searchfilter',file_name,'wget',extra=cl_options)
  r <- extract_info(file_name)
  name=c(name,r[1])
  email=c(email,r[2])
}

df<-data.frame(name=name,email=email)
print(df)
write.table(df,file="list.txt", row.names = FALSE, sep=",", quote=FALSE)