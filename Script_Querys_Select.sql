/* Realizado no banco fornecido na AWS pelo professor. */

--1º Listar todos os cliente que tem o nome 'ANA'.> Dica: Buscar sobre função Like
select c.* from 
	cliente c 
	where c.nome ilike '%ANA%';

--2º Pedidos feitos em 2023
select * from pedido p 
	where p.data_criacao >= '01-01-2023'
		and p.data_criacao < '01-01-2024';
	
--3º Pedidos feitos em Janeiro de qualquer ano
select * from pedido p 
	where to_char(p.data_criacao, 'MM') = '01';

--4º Itens de pedido com valor entre R$2 e R$5
select ip.valor, ip.quantidade, p.descricao  from 
	item_pedido ip join produto p on p.id = ip.id_produto  
	where ip.valor between 2 and 5;

--5º Trazer o Item mais caro comprado em um pedido
select * from (
	select ip.id_pedido, max(ip.valor) "valor"
		from item_pedido ip group by ip.id_pedido) a 
	join item_pedido ip2 on a.id_pedido = ip2.id_pedido and a."valor" = ip2.valor
	join produto p on p.id = ip2.id_produto 
	
--6º Listar todos os status diferentes de pedidos;
select distinct status from pedido p;

--7º Listar o maior, menor e valor médio dos produtos disponíveis.
select max(valor) "máximo",min(valor) "mínimo",avg(valor) "média" from produto p; 

--8º Listar fornecedores com os dados: nome, cnpj, logradouro, numero, cidade e uf de todos os fornecedores;
select f.nome, f.cnpj, e.logradouro, e.numero, e.cidade, e.uf  from fornecedor f 
	join endereco e on e.id = f.id_endereco;

--9º Informações de produtos em estoque com os dados: id do estoque, descrição do produto, quantidade do produto no estoque, logradouro, numero, cidade e uf do estoque;
select e.id,p.descricao, ie.quantidade, en.logradouro, en.numero, en.cidade, en.uf from estoque e 
	join endereco en  on e.id_endereco = en.id 
	join item_estoque ie on ie.id_estoque = e.id 
	join produto p on p.id = ie.id_produto

--10º Informações sumarizadas de estoque de produtos com os dados: descrição do produto, código de barras, quantidade total do produto em todos os estoques;
select p.descricao,p.codigo_barras, sum(ie.quantidade) "quantidade total" from item_estoque ie
	join produto p on p.id = ie.id_produto 
group by p.id, p.descricao,p.codigo_barras; 

--11º Informações do carrinho de um cliente específico (cliente com cpf '26382080861') com os dados: descrição do produto, quantidade no carrinho, valor do produto.
select p.descricao, ic.quantidade, p.valor from item_carrinho ic 
	join cliente c on c.id = ic.id_cliente 
	join produto p on ic.id_produto = p.id 
	where c.cpf ='26382080861';

--12º Relatório de quantos produtos diferentes cada cliente tem no carrinho ordenado pelo 
	--cliente que tem mais produtos no carrinho para o que tem menos, 
	--com os dados: id do cliente, nome, cpf e quantidade de produtos diferentes no carrinho.
select c.id, c.nome, c.cpf, count(*) as "quantidade_de_produtos" from cliente c 
	join item_carrinho ic on ic.id_cliente = c.id
	group by c.id, c.nome, c.cpf
	order by "quantidade_de_produtos" desc;

--13º Relatório com os produtos que estão em um carrinho a mais de 10 meses, 
	--ordenados pelo inserido a mais tempo, com os dados: 
	--id do produto, descrição do produto, data de inserção no carrinho, id do cliente e nome do cliente;
select p.id, p.descricao , ic.data_insercao, c.id,c.nome  from item_carrinho ic 
	join cliente c on c.id = ic.id_cliente 
	join produto p on ic.id_produto = p.id 
	where ic.data_insercao < CURRENT_DATE - interval '10 months'
	order by ic.data_insercao;

--14º Relatório de clientes por estado, 
	--com os dados: uf (unidade federativa) e quantidade de clientes no estado;
select e.uf,count(*) from cliente c 
	join endereco e on e.id = c.id_endereco
	group by e.uf 
	order by e.uf;

--15º Listar cidade com mais clientes e a quantidade de clientes na cidade;
select e.cidade,count(*) as "quantidade_de_clientes" from cliente c 
	join endereco e on e.id = c.id_endereco
	group by e.cidade
	order by "quantidade_de_clientes" desc;

--16º Exibir informações de um pedido específico, pedido com id 952, com os dados 
	--(não tem problema repetir dados em mais de uma linha): nome do cliente, id do pedido, 
	--previsão de entrega, status do pedido, descrição dos produtos comprados, quantidade comprada produto, valor total pago no produto;
select c.nome, p.id, p.previsao_entrega, p.status, prd.descricao, ip.quantidade, ip.valor  from pedido p 
	join item_pedido ip on ip.id_pedido = p.id
	join cliente c on c.id = p.id_cliente 
	join produto prd on prd.id = ip.id_produto 
where p.id = 952; 


--17º Relatório de clientes que realizaram algum pedido em 2022, 
	--com os dados: id_cliente, nome_cliente, data da última compra de 2022;
select c.id, c.nome,max(p.data_criacao) from cliente c 
	join pedido p on p.id_cliente = c.id 
	where p.data_criacao between '2022-01-01' and '2022-12-31'
	group by c.id , c.nome; 
	order by p.data_criacao;

--18º Relatório com os TOP 10 clientes que mais gastaram esse ano, 
	--com os dados: nome do cliente, valor total gasto;
select c.nome, sum(ip.quantidade * ip.valor) valor_gasto from cliente c 
	join pedido p on p.id_cliente = c.id
	join item_pedido ip on ip.id_pedido = p.id 
	where p.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO')
	group by c.id, c.nome
	order by valor_gasto desc
	limit 10;

--19º Relatório com os TOP 10 produtos vendidos esse ano, 
	--com os dados: descrição do produto, quantidade vendida, valor total das vendas desse produto;
select p.descricao,sum(ip.quantidade) quantidade_vendida,sum(ip.quantidade * ip.valor) valor_total_vendido from produto p 
	join item_pedido ip on ip.id_produto = p.id
	join pedido ped on ped.id = ip.id_pedido 
	where ped.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO')
	group by p.id,p.descricao
	order by quantidade_vendida desc
	limit 10; 

--20º Exibir o ticket médio do nosso e-commerce, ou seja, 
	--a média dos valores totais gasto em pedidos com sucesso;
select round(avg(ip.quantidade * ip.valor),2) from pedido p 
	join item_pedido ip on ip.id_pedido = p.id
	where p.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO');

--21º Relatório dos clientes gastaram acima de R$ 10000 em um pedido, 
	--com os dados: id_cliente, nome do cliente, valor máximo gasto em um pedido;
select a.id, a.nome, max(valor_gasto) maior_valor_gasto from (
	select c.id, c.nome, sum(ip.quantidade * ip.valor) "valor_gasto" from cliente c 
	join pedido p on p.id_cliente = c.id
	join item_pedido ip on ip.id_pedido = p.id 
	where p.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO')
	group by c.id, c.nome, p.id
	having 
		sum(ip.quantidade * ip.valor) > 10000) as a
	group by a.id,a.nome
	order by maior_valor_gasto desc;

--22º Listar TOP 10 cupons mais utilizados e o total descontado por eles.
select c.id, c.descricao, count(*) quantidade_usada, sum(c.valor) desconto_total from pedido p 
	join cupom c on c.id = p.id_cupom 
	where p.status not in ('PENDENTE_CONFIRMACAO_PAGAMENTO','CANCELADO')
	group by c.id, c.descricao 
	order by quantidade_usada desc
	limit 10;

--23º Listar cupons que foram utilizados mais que seu limite;
select c.id, c.descricao, count(*) quantidade_usada, c.limite_maximo_usos from pedido p 
	join cupom c on c.id = p.id_cupom
	group by c.id, c.descricao,c.limite_maximo_usos
	having count(*) > c.limite_maximo_usos 
	order by quantidade_usada desc;

--24º Listar todos os ids dos pedidos que foram feitos por pessoas que moram em São Paulo 
	--(unidade federativa, uf, SP) e compraram o produto com código de barras '97692630963921';
select p.id, c.nome, e.uf, e.cidade, e.logradouro, prod.descricao, prod.codigo_barras, p.data_criacao, p.previsao_entrega, p.status, 
		p.meio_pagamento, p.id_cupom from pedido p 
	join cliente c on c.id = p.id_cliente 
	join endereco e on e.id = c.id_endereco 
	join item_pedido ip on ip.id_pedido = p.id 
	join produto prod on prod.id = ip.id_produto 
	where e.UF = 'SP' and prod.codigo_barras = '97692630963921';
	



