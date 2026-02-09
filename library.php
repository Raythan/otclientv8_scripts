<?php
/**
 * Biblioteca de Itens - Classic-Global
 * Lê o arquivo items.xml e gera uma tabela pesquisável.
 */

// Caminho para o seu arquivo XML (ajuste se necessário, ex: 'items.xml' ou 'data/items/items.xml')
$xmlFile = 'items.xml'; 

// Verifica se o arquivo existe
if (!file_exists($xmlFile)) {
    echo "<div class='TableContainer'><div class='BoxContent'>Erro: Arquivo $xmlFile não encontrado.</div></div>";
    return;
}

$xml = simplexml_load_file($xmlFile);
?>

<!-- Inclusão do CSS e JS do DataTables (CDN) para a função de busca e paginação -->
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.css">
<style>
    /* Estilização para combinar com o Tibia Layout */
    .dataTables_wrapper { font-family: Verdana, Arial, Sans-Serif; font-size: 11px; color: #5A2800; margin-bottom: 10px; }
    .dataTables_length, .dataTables_filter { margin-bottom: 10px; font-weight: bold; }
    .dataTables_wrapper .dataTables_length select, .dataTables_wrapper .dataTables_filter input { border: 1px solid #793d03; background-color: #f1e0c6; padding: 2px; }
    
    /* Ajuste da Tabela */
    table.dataTable thead th {
        background-color: #D4C0A1;
        border-bottom: 1px solid #793d03;
        color: #000;
    }
    table.dataTable tbody tr { background-color: #F1E0C6; }
    table.dataTable tbody tr:hover { background-color: #E8D4B0; cursor: pointer;}
    table.dataTable.no-footer { border-bottom: 1px solid #793d03; }
    
    /* Esconde bordas extras do DataTables */
    .dataTables_wrapper .dataTables_paginate .paginate_button { padding: 0.2em 0.5em; }
    .dataTables_wrapper .dataTables_paginate .paginate_button.current, 
    .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
        background: #D4C0A1; border: 1px solid #793d03; color: black !important;
    }
</style>

<div id="library" class="Box">
    <div class="Corner-tl" style="background-image:url(./layouts/tibiarl/images/content/corner-tl.gif);"></div>
    <div class="Corner-tr" style="background-image:url(./layouts/tibiarl/images/content/corner-tr.gif);"></div>
    <div class="Border_1" style="background-image:url(./layouts/tibiarl/images/content/border-1.gif);"></div>
    <div class="BorderTitleText" style="background-image:url(./layouts/tibiarl/images/content/title-background-green.gif);"></div>
    <!-- Título da Box -->
    <img id="ContentBoxHeadline" class="Title" src="pages/headline.php?txt=Library" alt="Contentbox headline" style="display:none;"> <!-- Se não tiver gerador de imagem, use texto abaixo -->
    <div style="position: absolute; top: 12px; left: 15px; font-weight: bold; color: white; font-size: 14px; text-shadow: 1px 1px 0 #000;">Biblioteca de Itens</div>

    <div class="Border_2">
        <div class="Border_3">
            <div class="BoxContent" style="background-image:url(./layouts/tibiarl/images/content/scroll.gif); padding: 10px;">
                
                <div class="TableContainer">
                    <table class="TableContent" width="100%" style="border:1px solid #faf0d7;">
                        <tr>
                            <td>
                                <div style="background-color: #F1E0C6; padding: 10px; border: 1px solid #793d03; margin-bottom: 15px;">
                                    <strong>Bem-vindo à Biblioteca!</strong><br>
                                    Utilize o campo de busca abaixo para encontrar itens por ID, Nome ou Atributos (ex: "attack", "armor").
                                </div>
                                
                                <table id="itemsTable" class="display" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th width="10%">ID</th>
                                            <th width="5%">Img</th>
                                            <th width="30%">Nome</th>
                                            <th width="55%">Propriedades</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <?php
                                    foreach ($xml->item as $item) {
                                        $id = (string)$item['id'];
                                        // Alguns itens no seu XML usam IDs compostos (ex: 100-200), tratamos isso
                                        $displayId = $id; 
                                        if(isset($item['fromid']) && isset($item['toid'])) {
                                            $displayId = $item['fromid'] . '-' . $item['toid'];
                                        }

                                        $name = (string)$item['name'];
                                        $article = isset($item['article']) ? (string)$item['article'] . ' ' : '';
                                        
                                        // Caminho da imagem (Ajuste o path conforme sua pasta de imagens de itens)
                                        // Geralmente é images/items/{id}.gif
                                        $imagePath = "./images/items/" . $id . ".gif";
                                        $imgTag = file_exists($imagePath) ? "<img src='$imagePath' width='32'>" : "";

                                        // Processa os atributos internos (key/value)
                                        $attributesList = [];
                                        if (isset($item->attribute)) {
                                            foreach ($item->attribute as $attr) {
                                                $key = ucfirst((string)$attr['key']);
                                                $val = (string)$attr['value'];
                                                $attributesList[] = "<b>$key:</b> $val";
                                            }
                                        }
                                        $attrString = implode(" | ", $attributesList);

                                        echo "<tr>";
                                        echo "<td align='center'>$displayId</td>";
                                        echo "<td align='center'>$imgTag</td>";
                                        echo "<td><strong>" . ucfirst($name) . "</strong> <br><small>($article$name)</small></td>";
                                        echo "<td><small>$attrString</small></td>";
                                        echo "</tr>";
                                    }
                                    ?>
                                    </tbody>
                                </table>

                            </td>
                        </tr>
                    </table>
                </div>

            </div>
        </div>
    </div>
    <div class="Border_1" style="background-image:url(./layouts/tibiarl/images/content/border-1.gif);"></div>
    <div class="CornerWrapper-b"><div class="Corner-bl" style="background-image:url(./layouts/tibiarl/images/content/corner-bl.gif);"></div></div>
    <div class="CornerWrapper-b"><div class="Corner-br" style="background-image:url(./layouts/tibiarl/images/content/corner-br.gif);"></div></div>
</div>

<!-- Script para ativar o DataTables -->
<script type="text/javascript" src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<script>
$(document).ready(function() {
    $('#itemsTable').DataTable({
        "order": [[ 0, "asc" ]], // Ordenar por ID
        "pageLength": 25,        // Itens por página
        "lengthMenu": [[10, 25, 50, 100], [10, 25, 50, 100]],
        "language": {
            "sEmptyTable": "Nenhum registro encontrado",
            "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
            "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
            "sInfoFiltered": "(Filtrados de _MAX_ registros)",
            "sInfoPostFix": "",
            "sInfoThousands": ".",
            "sLengthMenu": "_MENU_ resultados por página",
            "sLoadingRecords": "Carregando...",
            "sProcessing": "Processando...",
            "sZeroRecords": "Nenhum registro encontrado",
            "sSearch": "Pesquisar:",
            "oPaginate": {
                "sNext": "Próximo",
                "sPrevious": "Anterior",
                "sFirst": "Primeiro",
                "sLast": "Último"
            },
            "oAria": {
                "sSortAscending": ": Ordenar colunas de forma ascendente",
                "sSortDescending": ": Ordenar colunas de forma descendente"
            }
        }
    });
});
</script>