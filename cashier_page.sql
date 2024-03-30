SELECT a.prod_id, a.prod_name, a.prod_img_url, a.amount, p.price FROM allProdInBranch(2) a
    INNER JOIN products p ON a.prod_id = p.prod_id