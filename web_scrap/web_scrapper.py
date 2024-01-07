import requests
from bs4 import BeautifulSoup, Tag
import json
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError, TransportError, NotFoundError

els = []
es = Elasticsearch("http://localhost:9200")  # Substitua pelo URL do seu Elasticsearch, se necessário
index_name = 'nome_do_indice'
url = 'https://prompthero.com/prompt/2089cd678b1-midjourney-5-2-a-colored-painting-of-a-pretty-woman-with-an-eye-for-detail-in-the-style-of-richard-phillips-shepard-fairey'
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}
response = requests.get(url, headers=headers)

# Verifique se a solicitação foi bem-sucedida
if response.status_code == 200:
    # Obtenha o conteúdo HTML da resposta
    html_content = response.text
    
    # Crie um objeto BeautifulSoup para analisar o HTML
    soup = BeautifulSoup(html_content, 'html.parser')

    # Função para converter um elemento BeautifulSoup em um dicionário
    def element_to_dict(element):
        if element.name == 'script' \
	or element.name == 'button' \
	or element.name == 'hr' \
	or element.name == 'br' \
	or element.name == 'style' \
	or element.name == 'footer':
            return None  # Ignora tags
        else:
            found = False
            for e in els:
                if e == element.name:
                    found=True; break
            if found == False:
                els.append(element.name)	    
        
        element_dict = {'tag': element.name}
        if element.attrs:
            element_dict['attributes'] = element.attrs
        if element.text:
            element_dict['text'] = element.get_text(strip=True)
        
        children = [element_to_dict(child) for child in element.children if isinstance(child, Tag)]
        # Filtra elementos None resultantes de tags <script>
        children = list(filter(None, children))
        if children:
            element_dict['children'] = children
        return element_dict
    
    # Cria uma lista para armazenar os elementos do HTML excluindo tags <script>
    elements_list = [element_to_dict(element) for element in soup.body.find_all(recursive=False) if element.name != 'script']

    document = {
        'url': url,
        'elements': elements_list
    }

    json = json.dumps(document, ensure_ascii=False)
    print(json)

    try:
        # Insira o documento no Elasticsearch
        result = es.index(index=index_name,  body=json)
    except ConnectionError:
        print("Não foi possível se conectar ao Elasticsearch.")
    except TransportError as e:
        print(f"Erro de transporte ao inserir o documento: {e.info}")
    except NotFoundError:
        print(f"Índice '{index_name}' não encontrado.")
    except Exception as e:
        print(f"Um erro desconhecido ocorreu: {e}")
else:
    print("Falha ao acessar a URL: Status Code", response.status_code)


for el in els:
	print(el)
