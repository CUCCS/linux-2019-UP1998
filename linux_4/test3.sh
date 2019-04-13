#!/bin/bash
function usage
{
echo '-a           统计访问来源主机TOP 100和分别对应出现的总次数'
echo '-b           统计访问来源主机TOP 100 IP和分别对应出现的总次数'
echo '-c           统计最频繁被访问的URL TOP 100'
echo '-d           统计不同响应状态码的出现次数和对应百分比'
echo '-e           分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数'
echo '-f <url>     给定URL输出TOP 100访问来源主机'
echo '-h           help'
}

# -a 统计访问来源主机TOP 100和分别对应出现的总次数
function sourceHost
{
	sed -e '1d' web_log.tsv|awk -F '\t' '{a[$1]++} END {for(i in a) {print i,a[i]}}'|sort -nr -k2|head -n 100

}

# -b 统计访问来源主机TOP 100 IP和分别对应出现的总次数
function sourceIP
{
	sed -e '1d' web_log.tsv|awk -F '\t' '{if($1~/^(([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+)\.([0-2]*[0-9]+[0-9]+))$/) print $1}'|awk '{a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k2|head -n 100

}

# -c 统计最频繁被访问的URL TOP 100
function mostURL
{
	sed -e '1d' web_log.tsv |awk -F\\t '{print $5}'|sort|uniq -c |sort -n -k 1 -r|head -n 10 

}

# -d 统计不同响应状态码的出现次数和对应百分比
function responce
{
	sed -e '1d' web_log.tsv | awk -F '\t' '{a[$6]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | head -n 100
    	sed -e '1d' web_log.tsv | awk -F '\t' '{a[$6]++} END {for(i in a){print i,a[i] }}' |  sort -nr -k2 | awk '{arr[$1]=$2;sums+=$2} END {for (k in arr) print k,arr[k]/sums*100,"%"}'

}

# -e 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function code
{
	 sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^403/) {a[$6":"$1]++}} END {for(i in a){print i,a[i] }}' | sort -nr -k2 | head -n 10
         sed -e '1d' web_log.tsv | awk -F '\t' ' {if($6~/^404/) {a[$6":"$1]++}} END {for(i in a){print i,a[i] }}' | sort -nr -k2 | head -n 10

}

# -f <url>     给定URL输出TOP 100访问来源主机
function URL
{
	(sed -e '1d' web_log.tsv|awk -F '\t' '{if($5=="'$1'") a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k2|head -n 10)

}

while [ "$1" != "" ]; do
    case $1 in
        -a )                    ifsourceHost=1
                                ;;
        -b )                    ifsourceIP=1
                                ;;
        -c )                    ifmostURL=1
                                ;;
        -d )                    ifresponce=1
                                ;;        
	-e )                    ifcode=1
                                ;;     
	-f )                    ifURL=1
				shift
				if [[ $1 != -* && $1 ]]
                                then
                                    url=$1
                                else
                                    echo "Warnning: There need a argument after -u"
                                    exit
                                fi
                                ;;        
	-h )            	usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [[ $ifsourceHost ]]
then
    sourceHost
fi
if [[ $ifsourceIP ]]
then
    sourceIP
fi
if [[ $ifmostURL ]]
then
    mostURL
fi
if [[ $ifresponce ]]
then
    responce
fi
if [[ $ifcode ]]
then
    code
fi
if [[ $ifURL && $url ]]
then
    URL $url
fi

