load("d:/0800/data20170421/memo.Rdata")
memo<-memo[1:50]

library(rJava)
library(NLP)
library(tm)
library(tmcn)
library(Rwordseg)

corp = Corpus(VectorSource(memo))

corp = tm_map(corp, stripWhitespace) 
corp = tm_map(corp, removePunctuation)

corp = tm_map(corp, removeNumbers) 
corp = tm_map(corp, function(word){
				gsub("[A-Za-z0-9]","",word)})
#corp = tm_map(corp, PlainTextDocument)

#corp = tm_map(corp, removeWords,stopwords("english"))

#人名辨識，不要用
#segment.options(isNameRecognition=TRUE)
installDict(dictpath = "D:/dictionary_r.txt",dictname = "insurance",dicttype = "text")

corp0427rws = tm_map(corp, content_transformer(segmentCN), returnType = 'tm')
#corp2 = tm_map(corp, segmentCN, nature = TRUE,returnType = 'tm')

#corp2 <- Corpus(VectorSource(corp2))

stopss = stopwordsCN()
corp0427rws = tm_map(corp0427rws,removeWords, stopss)
corp0427rws3 = Corpus(VectorSource(corp0427rws))

tdm = TermDocumentMatrix(corp0427rws3, 
			control = list(wordLengths = c(2, Inf)))

dtm = DocumentTermMatrix(corp0427rws3,
                         control = list(wordLengths = c(2,8),
                                        weighting =  function(x)
                                          weightTfIdf(x, normalize =  FALSE)))
