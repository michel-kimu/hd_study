package users 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class User 
	{
		private var id:String = '';							//DB에 등록되어있는 ID, -1로 서버에 전송하면 신규작성, 아니면 기존데이터의 갱신임
		private var kensa:String ='';						//검사자 이름
		private var name:String = '';
		
		private var age:String = '';						//나이
		private var sex:String = '';						//0:여, 1:남
		private var rrn:String = ''; 						//주민등록 번호
		private var gakureki:String = '';					//학력 (총 몆년?)
		private var arrRsltHistory:Array = new Array();		//[년/월/일],[치매 점수],[평가 (0:치매, 1:정상)],[우을증 점수],[평가(0:우울, 1:정상)] 순임
		
		//서버로 부터 전달 받은 문자열을 파싱한뒤, 각각 User 오브젝트로 담아서 Global.users 배열에 집어 넣어 관리함.
		
		public function User():void{
		}
				
		/*
		 * 데이터 형식)
		 * 
		 * [ID],[검사자],[이름],[성별],[나이],[주민번호],[학력],[검진이력->[년/월/일],[치매 점수],[평가 (0:치매, 1:정상)],[우을증 점수],[평가(0:우울, 1:정상)]]
		 * 예) 박규리,홍길동,23,1,921012,12,2017/01/10,50,0,10,1,2018/01/12,10,0,10,0 등등..
		 */
		public function Parse(data:String):void{
			var tmp:Array = data.split(',');
			
			trace('*****Data Parse********************');
			setID(tmp[0]);
			setKensaName(tmp[1]); 
			setName(tmp[2]); 
			setAge(tmp[3]);
			setSex(tmp[4]);
			setRrn(tmp[5]);
			setGakureki(tmp[6]);
			
			addHistory([tmp[7], tmp[8], tmp[9], tmp[10], tmp[11]]); 		//1회차 검진이력, [년월일][치매점수][치매판정][우울점수][우울판정] (0:우울,치매,1:정상)
			addHistory([tmp[12], tmp[13], tmp[14], tmp[15], tmp[16]]);		//2회차 검진이력
			
			printMyInfo();
		}
		
		//ID 지정
		public  function setID(num:*=''):void{
			id = (num == undefined || num == '')?'-1': num;
		}
		
		//검사자 지정
		public  function setKensaName(namae:*):void{
			kensa = (namae == undefined || namae == '')?'-': namae;
		}
		
		//이름 지정
		public function setName(namae:*):void{
			name = (namae == undefined || namae == '')?'-': namae;
		}
		
		public function setAge(tosi:*):void{
			age = (tosi == undefined || tosi == '')?'-':tosi;
		}
		
		public function setSex(seibetu:*):void{
			sex = ( seibetu == undefined || seibetu == '' )?'-':seibetu;
		}
		
		public function setRrn(num:*):void{
			rrn = ( num == undefined || num == '')?'-':num;
		}
		
		public function setGakureki(gaku:*):void{
			gakureki = ( gaku == undefined || gaku == '')?'-':gaku;
		}
		
		public function addHistory(arr:Array):void{
			
			if (arr[0] == undefined || arr[0] == ''){
				trace('불명한 검사 데이터 입력')
				return;
			}
			var tmp:Object = {date:'', score:'', result:'', sgdsscore:'', sgdsresult:''};
			
			tmp.date = arr[0];
			tmp.score = arr[1];
			tmp.result = arr[2];
			tmp.sgdsscore = arr[3];
			tmp.sgdsresult = arr[4];
			
			/*
			trace('날짜:'+ tmp.date);
			trace('치매 점수:'+ tmp.score);
			trace('치매 결과:' + tmp.result);
			trace('우울 점수:' + tmp.sgdsscore);
			trace('우울 결과:' + tmp.sgdsresult);
			
			trace('length:' + arrRsltHistory.length); 
			*/
			
			if (arrRsltHistory.length >=  2){		//항상 과거 2번의 이력만 남기기
				arrRsltHistory.shift(); 			// 맨 앞요소를 제거
				trace('첫번째 자료 삭제');
			}
			trace('자료 추가합니다');
			arrRsltHistory.push(tmp); 				//뒤에 추가
		}
		
		public function getId():String{
			return id;
		}
		//검진자 이름
		public function getKensaSyaName():String{
			return kensa;
		}
		
		public function getName():String{
			return name;
		}
			
		public function getAge():String{
			return age;
		}
		
		public function getSex():String{
			return sex;
		}
		
		public function getRrn():String{
			return rrn;
		}
		
		public function getGakureki():String{
			return gakureki;
		}
		
		public function getResultHistory():Array{
			return arrRsltHistory;
		}
		
		public function getLastKensaDate():String{
			
			var d:String = arrRsltHistory[arrRsltHistory.length - 1].date;
			trace('>'+String);
			return d;
		}
		
		public function printMyInfo():void{
			trace('*************************');
			trace('>id:' + id); 
			trace('>name:' + name); 
			trace('>age:' + age);
			trace('>sex:' + sex);
			trace('>rrn:' + rrn);
			trace('>gakureki:' + gakureki);
			trace('>---------------------');
			for (var i:int = 0 ; i < arrRsltHistory.length ; i++){
				trace('>date:' + arrRsltHistory[i].date);
				trace('>치매 score:' + arrRsltHistory[i].score);
				trace('>치매 result:' + arrRsltHistory[i].result);
				trace('>우울 score:' + arrRsltHistory[i].sgdsscore);
				trace('>우울 result:' + arrRsltHistory[i].sgdsresult);
			}
			trace('>---------------------');
		}
	}
	
}