library(XML)

extract_info <- function(file_name)
{
  doc <- htmlParse(file_name)
  local_name = c()
  local_email = c()
  for ( i in seq(1,10) ){
    name_xpath = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
    name_xpath = paste(name_xpath,']/section[2]/a',sep='')
    x<-xpathSApply(doc,name_xpath,xmlValue)
    
    no_description = FALSE
    if(length(x)==0){
      no_description = TRUE
      name_xpath = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
      name_xpath = paste(name_xpath,']/section[2]',sep='')
      x<-xpathSApply(doc,name_xpath,xmlValue)     
      if(is.null(x)){
        x<-'no_name'
      } else {
        x<-strsplit(x,'\n')[[1]][2]
      }
    }
    local_name=c(local_name,x)


    email_xpath_1 = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
    email_xpath_1 = paste(email_xpath_1,']/section[3]/p/a[1]',sep='')
    x1<-xpathSApply(doc,email_xpath_1,xmlValue)
    if(is.null(x1) || length(x1)==0 || x1==''){
      x1='no_mail'
    }    
    
    email_xpath_2 = paste('//*[@id="templ-housinglist"]/div[2]/div/section/ul/li[',i,sep='')
    email_xpath_2 = paste(email_xpath_2,']/section[3]/p/a[2]',sep='')
    x2<-xpathSApply(doc,email_xpath_2,xmlValue)
    if(is.null(x2) || length(x2)==0 || x2==''){
      x2='no_mail'
    }        
    
    if ( '@' %in% strsplit(x1,'')[[1]] ) {
      x=x1
    } else {
      if ( '@' %in% strsplit(x2,'')[[1]] ) {
        x=x2
      } else {
        x='unexpected'
      }
    }

    local_email = c(local_email,x)
  }
  if(length(local_name)==length(local_email)){
    df <- data.frame(name=local_name,email=local_email)
    file_name = paste('list_',j,sep='')
    file_name = paste(file_name,'.txt',sep='')
    write.table(df,file=file_name, row.names = FALSE, sep=",", quote=FALSE)  
  }

  return(data.frame(name=local_name,email=local_email))
}

name=c()
email=c()

for ( j in seq(0,1536,10) ) {
  cl_options <- paste('--post-data "search=1&feratelSort=3&feratelOffset=',j,sep='')
  cl_options <- paste(cl_options,'"',sep='')
  file_name = paste('f_',j,sep='')
  file_name = paste(file_name,'.html',sep='')
  download.file('http://www.oetztal.com/accommodation-list-winter#searchfilter',file_name,'wget',extra=cl_options)
  r <- extract_info(file_name)
  name=c(name,as.vector(r$name))
  email=c(email,as.vector(r$email))
}

df<-data.frame(name=name,email=email)
print(df)
write.table(df,file="list.txt", row.names = FALSE, sep=",", quote=FALSE)